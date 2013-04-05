$(document).ready ->
  $('input#acquisition_date').datepicker dateFormat: "yy-mm-dd"
  $('a#confirmaddmusic').click (e) ->
    e.preventDefault()
    haveText = $.trim($('span#havemusic').text())
    $albumLink = $('a#addmusic')
    labels = []
    $('li.token-input-token p').each ->
      labels.push $(this).text()
    if $.trim($albumLink.text()) != haveText
      jqxhr = $.post '/possessions.json',
        possession:
          release_id: $(this).attr 'data-album-id'
          labels: labels
          comments: $('textarea#comments').val()
          acquisition_date: $('input#acquisition_date').val()
          rating: $('input#rating').val()
        (data) =>
          $(this).attr 'data-possession-id', data._id
          $albumLink.text haveText
          $(this).text $('span#update').text()
          $('#addmusicform').modal('hide')
      jqxhr.fail (data) ->
        console.log data
        alert $('span#adderror').text()
    else
      jqxhr = $.post "/possessions/#{$(this).attr 'data-possession-id' }.json",
        _method: 'PUT'
        possession:
          labels: labels
          comments: $('textarea#comments').val()
          acquisition_date: $('input#acquisition_date').val()
          rating: $('input#rating').val()
        (data) ->
          console.log data
          $albumLink.text haveText
          $('#addmusicform').modal('hide')
      jqxhr.fail (data) ->
        console.log data
        alert $('span#adderror').text()