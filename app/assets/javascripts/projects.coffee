updatePalette = ->
  thumb = $('.dropzone .dz-preview img').last()
  if thumb.length > 0
    if palette = DevGarden.extractSignificantHues(thumb[0], 5)
      showPalette(palette)
  return

showPalette = (hues) ->
  for hueKey in ['primary', 'highlight']
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

autoselectThemeColors = ->
  for hueKey, i in ['highlight', 'primary']
    $choices = $("#theme-#{hueKey}-hue ol input")
    $choices[i % $choices.length].click()

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
              autoselectThemeColors()
        @on "maxfilesexceeded", (file) =>
          @removeAllFiles()
          @addFile(file)
    .find('.dz-preview img').load(updatePalette)
  updatePalette()
