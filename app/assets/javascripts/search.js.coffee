$("#q").livesearch 
  searchCallback: (searchTerm) ->
    alert('doing live search...')

  queryDelay: 250
  innerText: "Search"
  minimumSearchLength: 3