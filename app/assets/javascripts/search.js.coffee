$(document).ready ->
  # Handle search form submits via AJAX
  $("form").live "ajax:success", (event, data, status, xhr) ->
    new_url = $("form").attr('action') + '?' + $("form").serialize()
#    $("#debug").append "<p>#{JSON.stringify History}</p>"
    query = $("#q").val()
    state =
      query: query
      result: data
    History.pushState(state, "Search for #{query}", new_url)

((window, undefined_) ->
  History = window.History
  $(window).bind "statechange", ->
    State = History.getState()
    updateResults State.data
) window

updateResults = (state) ->
  $("#content").html state.result || ""
  $("#q").val state.query || ""
