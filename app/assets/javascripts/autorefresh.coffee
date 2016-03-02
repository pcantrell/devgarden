timeout = 200.0
$(document).on 'turbolinks:load', ->
  if $('.autorefresh-page').length > 0
    timeout += 2000 / Math.sqrt(timeout)
    setTimeout (-> Turbolinks.visit(location.toString())), timeout
  else
    timeout = 200
