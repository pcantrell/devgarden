updatePalette = ->
  thumb = $('.dropzone .dz-preview img').last()
  if thumb.length > 0
    if palette = DevGarden.extractSignificantHues(thumb[0], 5)
      showPalette(palette)
  return

buildPaletteUI = (hueKey, hues) ->
  $palette = $("#theme-#{hueKey}-hue ol")
  $palette.children().remove()
  for hue in hues
    radioID = "icon-#{hueKey}-#{hue}"
    $palette.append("
      <li>
        <input type='radio'
               name='project[theme][#{hueKey}_hue]'
               value='#{hue}'
               id='#{radioID}'>
        <label for='#{radioID}'
               style='background: hsl(#{hue}, 100%, 50%)'>
        </label>
      </li>")
  return

selectClosestToPreviousHue = (hueKey, index) ->
  $inputs = $("input[name='project[theme][#{hueKey}_hue]']")
  values = (parseFloat(input.value) for input in $inputs)
  return if values.length == 0

  prevValue = parseFloat($("#project_theme_previous_#{hueKey}_hue").val())
  prevValue ||= Math.random() * 360

  newValue = undefined
  closestDist = Infinity
  for value in values
    dist = Math.abs((value - prevValue + 540) % 360 - 180)
    if dist < closestDist
      closestDist = dist
      newValue = value

  if newValue
    $inputs.val([newValue])

  return

showPalette = (hues) ->
  for hueKey, i in ['primary', 'highlight']
    buildPaletteUI(hueKey, hues)
    selectClosestToPreviousHue(hueKey, i)
  return

$(document).on 'turbolinks:load', ->
  $('#project-icon-dropzone:not(.dropzone)')
    .addClass("dropzone")
    .dropzone
      paramName: "project[icon]"
      maxFilesize: 5 # MB
      useFullImageForThumbnail: true,
      acceptedFiles: "image/png,image/jpeg"

      # Based on http://stackoverflow.com/a/26035954/239816
      maxFiles: 1
      init: ->
        @on "addedfile", ->
          $('.dropzone .dz-preview:not(:last-child)').hide()
          $('.dropzone .dz-preview img').load ->
            updatePalette()
            $('#project-theme-form').submit()
        @on "maxfilesexceeded", (file) =>
          @removeAllFiles()
          @addFile(file)
    .find('.dz-preview img').load(updatePalette)
  updatePalette()
