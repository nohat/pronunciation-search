$ ->
  $("#pronbtn").click ->
    queryInput = $("#q")
    query = queryInput.val() + " //"
    queryInput.val(query)
    caretPos = query.length - 1
    queryInput.caret(caretPos)

  $("#spelbtn").click ->
    queryInput = $("#q")
    query = queryInput.val() + " <>"
    queryInput.val(query)
    caretPos = query.length - 1
    queryInput.caret(caretPos)

  