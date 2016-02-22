$ ->
  updateDisclosureInput = (elem, interactive) ->
    $input = $(elem)
    target_id = $input.closest('.disclosure-input').attr('data-disclosure-target')
    $target = $('#' + target_id).closest("li.input")
    $targetInput = $target.find("input")
    duration = (if interactive then 200 else 0)

    $target.addClass('disclosure-target')
    if $input.is(':checked')
      $target.slideDown(duration)
      $targetInput.focus() if interactive
    else
      $target.slideUp(duration)
      $targetInput.val(null) if interactive

  $(document).on 'change', '.disclosure-input input', (e) ->
    updateDisclosureInput(e.target, true)

  $(document).on 'page:update', ->
    for disclosure in $('.disclosure-input input')
      updateDisclosureInput(disclosure, false)
    true
