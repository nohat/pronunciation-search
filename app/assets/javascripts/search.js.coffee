$(document).ready ->
  $("form").live "ajax:success", (event, data, status, xhr) ->
    updateResults(data)
  $("#q").livesearch
    searchCallback: (searchTerm) ->
      $("form").submit()
    , minimumSearchLength: 5
updateResults = (data) ->
  $("#content").html data