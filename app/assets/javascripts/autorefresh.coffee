timeout = 200
$(document).on 'turbolinks:load', ->
  if $('.autorefresh-page').length > 0
    timeout = timeout * 1.1 + 100 if timeout < 5000
    setTimeout (-> Turbolinks.visit(location.toString())), timeout
  else
    timeout = 200
