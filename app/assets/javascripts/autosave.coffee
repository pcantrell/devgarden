submitIfDirty = ($form) ->
  autosubmitAtTime = $form.data('autosubmitAtTime')
  return unless autosubmitAtTime && Date.now() >= autosubmitAtTime

  $form.data('autosubmitAtTime', null)
  $form.submit()

$(document).on 'devgarden:scheduleAutosave', (e) ->
  $form = $(e.target).closest('form')
  throttle = 600
  $form.data('autosubmitAtTime', Date.now() + throttle)
  setTimeout (-> submitIfDirty($form)), throttle

$(document).on 'change', '.autosave input', (e) ->
  $(e.target).trigger('devgarden:scheduleAutosave')


# Status display

bindStatusUpdate = (eventType, status) ->
  $(document).on "ajax:#{eventType}", (e) ->
    $(e.target).data('autosave-status', status)
    updateStatusDisplay()

bindStatusUpdate("beforeSend", "saving")
bindStatusUpdate("success", "success")
bindStatusUpdate("error", "error")

updateStatusDisplay = ->
  statuses = $('.autosave')
    .map((i, elem) -> $(elem).data('autosave-status'))
    .toArray()

  globalStatus = "no-changes"
  for status in ["saving", "error", "success"]
    if statuses.includes(status)
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

