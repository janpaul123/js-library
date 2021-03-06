rightClick = (event=window.event) ->
  if event.which
    event.which == 3
  else if event.button
    event.button == 2
  else
    false

timeout = null

annotating = false

FactlinkJailRoot.startAnnotating = ->
  return if annotating
  annotating = true

  $("body").on "mouseup.factlink", (event) ->
    window.clearTimeout timeout
    FactlinkJailRoot.createButton.hide()

    # We execute the showing of the prepare menu inside of a setTimeout
    # because of selection change only activating after mouseup event call.
    # Without this hack there are moments when the prepare menu will show
    # without any text being selected
    timeout = setTimeout(->
      return if rightClick(event)

      # Check if the selected text is long enough to be added
      if FactlinkJailRoot.textSelected() && !$(event.target).is(":input")
        FactlinkJailRoot.createButton.placeNearSelection event.pageX
        FactlinkJailRoot.trigger "textSelected"
    , 200)

FactlinkJailRoot.stopAnnotating = ->
  return unless annotating
  annotating = false

  FactlinkJailRoot.createButton.hide()
  $("body").off "mouseup.factlink"


FactlinkJailRoot.host_ready_promise.done FactlinkJailRoot.startAnnotating
