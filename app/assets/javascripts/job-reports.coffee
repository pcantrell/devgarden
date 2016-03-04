$ ->
  $(document).on 'turbolinks:load', ->
    updateJobStatus = ->
      $.ajax
        url: location.toString()  # JSON request gives status updates
        complete: refresh
        success: (data) ->
          $('.job-report .message').text(data.message)
          if data.completed
            # Full HTML request gives post-completion layout / redirect
            Turbolinks.visit(location.toString(), action: "replace")

    timeout = 100.0
    refresh = ->
      if $('.job-report').length > 0
        setTimeout(updateJobStatus, timeout)
        timeout += 2000 / Math.sqrt(timeout)

    refresh()
