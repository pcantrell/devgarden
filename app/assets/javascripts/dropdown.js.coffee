isPopupVisible = ($button) ->
  $button.hasClass('dropdown-button-active')

resolvePopup = ($button) ->
  $dropdown = $('#' + $button.data('show-dropdown'))
  $header = if $button.data('dropdown-header')
    $('#' + $button.data('dropdown-header'))
  else
    $dropdown.parent()
  [$dropdown, $header]

curPopupButton = -> $('.dropdown-button-active')

positionCurPopup = ->
  [$dropdown, $header] = resolvePopup(curPopupButton())
  if $header?.length > 0
    headerOffset = $header.offset()
    $dropdown.offset(
      left: Math.max(0, headerOffset.left + $header.outerWidth() - $dropdown.outerWidth()),
      top:              headerOffset.top  + $header.outerHeight() - 1)

showPopup = ($button, show) ->
  return unless $button
  [$dropdown, $header] = resolvePopup($button)

  if show
    showPopup(curPopupButton(), false)
    $dropdown.css('min-width', "#{$header.outerWidth() + 24}px")
  
  $button.toggleClass('dropdown-button-active', show)

  updateHeaderState = -> $header.toggleClass('dropdown-header-active', show)
  action = if(show)
    $dropdown.slideDown(120)
    updateHeaderState()
  else
    $dropdown.slideUp(120, updateHeaderState)

  if show
    positionCurPopup()

    focus = ->
      $input = $dropdown.find('input')
      if $input.length > 0
        $input[0].focus()

    minScroll = Math.max(0, $dropdown.offset().top + 260 - $(window).height())
    if $(document).scrollTop() < minScroll
      $('html, body').animate(scrollTop: minScroll, focus)
    else
      focus()

togglePopup = ($button) ->
  showPopup $button, !isPopupVisible($button)

$ ->
  $(document).on 'click', '[data-show-dropdown]', (e) ->
    e.preventDefault()
    togglePopup($(e.target))

$(window).resize positionCurPopup
$(window).scroll ->
    setTimeout positionCurPopup, 1
