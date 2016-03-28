$ ->
  targetOfLink = ($link) ->
    $($link.attr('href') + "-tab")

  showTab = ($tab) ->
    $group = $tab.closest('.tabs')

    $group.find("> ul > li").toggleClass('active', false)
    href = ($tab.attr('id') || "").replace("-tab", "")
    $group.find("a[href='##{href}']").closest('li').toggleClass('active', true)

    $group.find('.tab').hide()
    $tab.show()

    $inputs = $tab.find("textarea, input[type=text]")
    if $inputs.length > 0 && $inputs.filter(":focus").length == 0
      $($inputs[0]).focus()

    saveTab($group, $tab)
  
  saveTab = ($group, $tab) ->
    groupID = $group.attr('id')
    tabID = $tab.attr('id')
    if sessionStorage && groupID && tabID
      sessionStorage.setItem("selected-tab:#{groupID}", tabID)

  restoreSavedTab = ($group) ->
    groupID = $group.attr('id')
    savedTabID = if sessionStorage && groupID
      sessionStorage.getItem("selected-tab:#{groupID}")
    savedTab = document.getElementById(savedTabID) || $group.find('.tab')[0]
    showTab($(savedTab))

  $(document).on 'turbolinks:load', ->
    $('.tabs > ul > li a').attr("data-turbolinks", false)
    for tabs in $('.tabs')
      restoreSavedTab($(tabs))
    showTab $(window.location.hash + "-tab")

  $(document).on 'click', '.tabs li a', (e) ->
    $tab = targetOfLink($(e.target).closest("a"))
    showTab($tab)
    return

  $(document).on 'click', '.next-tab', (e) ->
    $(e.target).closest('.tabs').scrollIntoView(false)
    showTab(
      $(e.target).closest('.tab').next())
