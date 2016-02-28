dirty = false
confirmUnload = (callback) ->
  if dirty
    callback 'You will lose your changes.'
  else
    undefined
$(window).bind 'beforeunload',       -> confirmUnload((msg) -> msg)
$(document).on 'page:before-change', -> confirmUnload((msg) -> confirm(msg))

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

$(document).on 'change', '.autosubmit-on-change input', (e) ->
  $(e.target).closest('form').submit()

$(document).on 'submit', '.autosubmit-on-change form', (e) ->
  e.preventDefault()
  $form = $(e.target)
  $.ajax
    type: $form.attr('method') || "POST"
    url: $form.attr('action') || '.'
    data: $form.serialize()
