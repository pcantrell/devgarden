$ ->
  applyHeadingParallax = ->
    scrollOffset = $(document).scrollTop()
    windowBottom = $(window).height()
    for heading in $('.summary-group h1')
      zeroPoint = Math.max(
        $(heading).offset().top - windowBottom,
        0)
      $(heading).css('top', "#{(scrollOffset - zeroPoint) / 2}px")

  applyHeadingParallax()
  $(window).scroll applyHeadingParallax
