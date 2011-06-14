$("input#q").livesearch 
  searchCallback: (searchTerm) ->
    alert('doing live search...' + searchTerm)

