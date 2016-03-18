# Confirm discard on close

anyFormsDirty = ->
  $('form').toArray().some (form) ->
    $(form).data('dirty')

confirmUnload = (callback) ->
  if anyFormsDirty()
    callback 'You will lose your changes.'
  else
    undefined

$(window).bind 'beforeunload', ->
  confirmUnload((msg) -> msg)

$(document).on 'turbolinks:before-visit', ->
  confirmUnload((msg) -> confirm(msg))

# Error handling

$(document).on 'turbolinks:load', ->
  bounce = ($elem) ->
    $elem.transition { scale: 1.1 }, 160, 'easeOutSine'
         .transition { scale: 1 },   240, 'easeInOutSine'

  bounce $('.flashes:not(.flashed)')
  $('.flashes').addClass('flashed')

  dirty = false
  $(document).on 'change', 'form *', (e) ->
    $(e.target).closest('form').data('dirty', true)
  $(document).on 'submit', 'form', (e) ->
    $(e.target).data('dirty', false)
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
