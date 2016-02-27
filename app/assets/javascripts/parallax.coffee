$ ->
  $window = $(window)
  $document = $(document)

  applyCoverParallax = ->
    scrollOffset = $document.scrollTop()
    for heading in $('.summary-group h1')
      $(heading).css('top', "#{scrollOffset / 2}px")

  applyCoverParallax()
  $window.scroll applyCoverParallax
