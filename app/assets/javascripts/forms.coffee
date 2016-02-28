# Confirm discard on close

dirty = false
confirmUnload = (callback) ->
  if dirty
    callback 'You will lose your changes.'
  else
    undefined
$(window).bind 'beforeunload',       -> confirmUnload((msg) -> msg)
$(document).on 'page:before-change', -> confirmUnload((msg) -> confirm(msg))

# Error handling

$(document).on 'page:update', ->
  bounce = ($elem) ->
    $elem.transition { scale: 1.1 }, 160, 'easeOutSine'
         .transition { scale: 1 },   240, 'easeInOutSine'

  bounce $('.flashes')

  dirty = false
  $('input').change ->
    dirty = true
  $('form').submit ->
    dirty = false
    true

  focusError = ->  
    $errors = $('form.formtastic .error input')
    if $errors.length > 0
      $errors[0].focus()
      for error in $errors
        bounce $(error)
      $errors.change (e) ->
        $parent = $(e.target).parent('.error')
        $parent.toggleClass('error', false)
        $parent.find('.inline-error').hide()
  setTimeout focusError, 0

  $('textarea').autogrow()

# Autosave

updateStatusDisplay = ->
  statuses = $('.autosave form')
    .map((i, elem) -> $(elem).data('autosave-status'))
    .toArray()

  globalStatus = "no-changes"
  for status in ["saving", "error", "success"]
    if statuses.includes(status)
      globalStatus = status
      break
  
  $('#autosave-status').children().hide()
  $("#autosave-status .#{globalStatus}").show()

autosaveStatus = ($form, status) ->
  $form.data('autosave-status', status)
  updateStatusDisplay()

retryFailedAutosaves = ->
  for form in $('.autosave form')
    if $(form).data('autosave-status') == 'error'
      $(form).submit()
  return

$(document).on 'page:update', updateStatusDisplay

$(document).on 'change', '.autosave input', (e) ->
  $(e.target).closest('form').submit()

$(document).on 'submit', '.autosave form', (e) ->
  e.preventDefault()
  $form = $(e.target)
  $.ajax
    type: $form.attr('method') || "POST"
    url: $form.attr('action') || '.'
    data: $form.serialize()
    beforeSend: -> autosaveStatus($form, 'saving')
    complete: (result, status) ->
      autosaveStatus $form,
        if status == 'success'
          retryFailedAutosaves()
          'success'
        else
          'error'

$(document).on 'click', '#autosave-status .error', (e) ->
  e.preventDefault()
  retryFailedAutosaves()
