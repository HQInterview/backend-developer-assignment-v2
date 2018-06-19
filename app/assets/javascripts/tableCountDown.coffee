app.ready ->
  cells = $(".expiration-time-table")
  $(cells).each ->
    expiredAt = parseInt $(this).text()
    $(this).countdown(expiredAt, (event) ->
      $(this).text event.strftime("%M:%S")
      $(this).addClass("blinking-once") if event.offset.minutes == 1 and event.offset.seconds == 0
      $(this).removeClass("text-green").addClass("text-red") if event.offset.minutes == 0
      $(this).removeClass("hidden") if $(this).hasClass("hidden")
      return
    ).on "finish.countdown", ->
      $(this).removeClass("text-red").addClass("text-blue")
      $(this).text "FINISHED"
      return
    return
  return
