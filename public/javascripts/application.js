// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
    $('#word_name').autocomplete({
//        source: "/words.js",
        source: function(request, response) {
            
            $.ajax({
                url: "/words.js",
                dataType: "json",
                data: {
                    q: request.term
                },
                success: function(data) {
                    response( $.map( data, function ( item ) {
                        return { label: item.word.name, value: item.word.friendly_id }
                    }))
                }
            });
        },
        select: function( event, ui ) {
            alert( ui.item ?
                "Selected: " + ui.item.label :
                "Nothing selected, input was " + this.value);
        },
        minLength: 2,
    });
})

