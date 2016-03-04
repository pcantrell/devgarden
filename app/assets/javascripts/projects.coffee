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
        @on "maxfilesexceeded", (file) =>
          @removeAllFiles()
          @addFile(file)
