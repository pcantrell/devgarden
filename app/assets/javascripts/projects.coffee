updatePalette = ->
  thumb = $('.dropzone .dz-preview img').last()
  if thumb.length > 0
    if palette = DevGarden.extractSignificantHues(thumb[0], 5)
      showPalette(palette)
  return

showPalette = (palette) ->
  $('main').append("<hr>")
  for hue in palette
    $('main').append("<div style='display: inline-block; width: 4em; height: 4em; background: hsl(#{hue}, 100%, 50%)'></div>")
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
          $('.dropzone .dz-preview img').load(updatePalette)
        @on "maxfilesexceeded", (file) =>
          @removeAllFiles()
          @addFile(file)
    .find('.dz-preview img').load(updatePalette)
