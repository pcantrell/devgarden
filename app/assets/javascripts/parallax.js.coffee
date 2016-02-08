$ ->
  $groups = $('.summary-group')
  if $groups.length > 0

    $window = $(window)
    $document = $(document)

    configureParallax = (group) ->
      $group = $(group)
      $heading = $group.find('h1')

      applyCoverParallax = ->
        scrollOffset = $document.scrollTop()
        $heading.css('top', "#{scrollOffset / 2}px")

      applyCoverParallax()
      $window.scroll applyCoverParallax

    for group in $groups
      configureParallax(group)
