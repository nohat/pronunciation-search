$(document).ready ->
#  alert("The DOM is now loaded and can be manipulated.")
  $('#q').show(5)
  $("#q").livesearch 
    searchCallback: (searchTerm) ->
      alert('doing live search...' + searchTerm)
