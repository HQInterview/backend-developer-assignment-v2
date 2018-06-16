app.ready ->
  timer = $(".expiration-time-room")
  if $(timer)
    expiredAt = parseInt $(timer).text()
    $(timer).countdown(expiredAt, (event) ->
      $(timer).text event.strftime("%M:%S")
      if event.offset.minutes == 0
        $(this).removeClass("text-green").addClass("text-red")
        $(timer).addClass("blinking") unless $(timer).hasClass("blinking")
      $(timer).removeClass("hidden") if $(timer).hasClass("hidden")
      return
    ).on "finish.countdown", ->
      $(timer).removeClass("blinking").removeClass("text-red").addClass("text-blue")
      $("#expiration_status").text("This Auction has ")
      $(timer).text "FINISHED"
      $(".form-inline").remove()
      return
    return
  return
