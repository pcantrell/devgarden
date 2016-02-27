$ ->
  $(document).on 'page:update', ->
    $('.tabbed-group .tabbed').hide()
    $('.tabbed-group .tabbed:first-child').show()

  tabSelector = '.tab[data-tab-target]'
  $(document).on 'click', tabSelector, (e) ->
    e.preventDefault()
    targetID = $(e.target).closest(tabSelector).data('tab-target')
    $target = $('#' + targetID)
    console.log targetID, $target
    $target.closest('.tabbed-group').find('.tabbed').hide()
    $target.show()
    null

