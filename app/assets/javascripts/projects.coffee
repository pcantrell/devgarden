updatePalette = ->
  $('.dropzone .dz-preview img').load ->
    thumb = $('.dropzone .dz-preview img').last()
    if thumb.length > 0
      $('main').append("<hr>")
      for weight, hue in DevGarden.huestogram(thumb[0])
        $('main').append("<div style='display: inline-block; width: 2px; height: 20px; background: hsl(#{hue}, 100%, #{Math.round(weight * 50)}%)'></div>")

      # if palette = DevGarden.extractHues(thumb[0])
      #   showPalette(palette)

showPalette = (palette) ->
  for c in palette
    $('main').append("<div style='display: inline-block; width: 4em; height: 4em; background: rgb(#{c.join(', ')})'></div>")

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
          updatePalette()
        @on "maxfilesexceeded", (file) =>
          @removeAllFiles()
          @addFile(file)
  
  updatePalette()
