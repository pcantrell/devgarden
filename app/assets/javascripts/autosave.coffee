submitIfDirty = ($form, opts = {}) ->
  autosubmitAtTime = $form.data('autosubmitAtTime')
  return unless autosubmitAtTime && (opts.immedately || Date.now() >= autosubmitAtTime)

  $form.data('autosubmitAtTime', null)
  $form.submit()

$(document).on 'devgarden:scheduleAutosave', (e) ->
  $form = $(e.target).closest('form')
  changeStatus($form, 'saving')
  throttle = 1200
  $form.data('autosubmitAtTime', Date.now() + throttle)
  setTimeout (-> submitIfDirty($form)), throttle

$(document).on 'change', '.autosave *', (e) ->
  $(e.target).trigger('devgarden:scheduleAutosave')

$(document).on 'turbolinks:before-visit', ->
  document.activeElement.blur()
  for form in $('.autosave')
    submitIfDirty($(form), immedately: true)

# Status display

changeStatus = ($form, status) ->
  $form.data('autosave-status', status)
  updateStatusDisplay()

bindStatusUpdate = (eventType, status) ->
  $(document).on "ajax:#{eventType}", (e) ->
    changeStatus($(e.target), status)

bindStatusUpdate("beforeSend", "saving")
bindStatusUpdate("success", "success")
bindStatusUpdate("error", "error")

arrayContainsValue = (array, value) ->
  for elem in array
    return true if elem == value
  false

updateStatusDisplay = ->
  statuses = $('.autosave')
    .map((i, elem) -> $(elem).data('autosave-status'))
    .toArray()

  globalStatus = "no-changes"
  for status in ["saving", "error", "success"]
    if arrayContainsValue(statuses, status)
      globalStatus = status
      break
  
  $('#autosave-status').children().hide()
  $("#autosave-status .#{globalStatus}").show()

$(document).on 'turbolinks:load', updateStatusDisplay

# Retry

retryFailedAutosaves = ->
  for form in $('.autosave')
    if $(form).data('autosave-status') == 'error'
      $(form).submit()
  return

$(document).on 'click', '#autosave-status .error', (e) ->
  e.preventDefault()
  retryFailedAutosaves()

$(document).on "ajax:success", retryFailedAutosaves

