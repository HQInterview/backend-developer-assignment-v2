app.ready ->
  cells = $(".expiration-time-table")
  $(cells).each ->
    expiredAt = parseInt $(this).text()
    $(this).countdown(expiredAt, (event) ->
      $(this).text event.strftime("%M:%S")
      $(this).show()
      return
    ).on "finish.countdown", ->
      $(this).text "EXPIRED"
      return
    return
  return
