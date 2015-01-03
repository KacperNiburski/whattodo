//= require jquery
//= require_tree .
$(document).ready(function() {
  $('.button').click(function() {
    $.get("/api/v1/create_token", function(data) {
      $('.key-holder').text("Your access token: " + data.access_token)
    })
  })

  $('#select-all').click(function() {
    $('input').attr('checked', 'checked')
  })

  $('#uncheck').click(function() {
    $('input').removeAttr('checked')
  })

  $('#approve-all').click(function() {
    var allData = [],
        url;
    $.each($('input:checked'), function(index, eventId) {
      var eventNum = $(eventId).val()
      allData.push(eventNum)
    })

    url = "/api/v1/approve"

    if (allData.toString() === [].toString()) {
      $('.target').text('Pick some events noob!')
    } else {
      $('.target').text('')
      $.ajax({
        url: url,
        type: "POST",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        dataType: "json",
        data: {events: allData },
        complete: function(data) {
          $('.all-output').html('')
          var jsonData = data.responseJSON['events']
          var htmlString = '<table><tr><th>Approve/Unapprove</th><th>Name</th><th>Approved</th><th>Location</th><th>Price</th><th>Latitude</th><th>Longitude</th><th>Url</th><th>Image</th><th>DayOn</th><th>DayEnd</th></tr>'
          $.each(jsonData, function(index, eventArr) {
            htmlString += '<tr><td><input id="event" name="event" type="checkbox" value="'+eventArr['ruby_id']+'"></td>'
            + '<td><label class="check-box" for="event">'+eventArr['name']+'</label></td>'
            +'<td>'+eventArr['approved']+'</td>'
            +'<td>'+eventArr['location']+'</td>'
            +'<td>'+eventArr['latitude']+'</td>'
            +'<td>'+eventArr['longitude']+'</td>'
            +'<td>'+eventArr['url']+'</td>'
            +'<td>'+eventArr['image']+'</td>'
            +'<td>'+eventArr['dayOn']+'</td>'
            +'<td>'+eventArr['dayEnd']+'</td>'
            +'</tr>'
          })
          htmlString += '</tr>'
          $('.all-output').html(htmlString)
        }
      })
    }
  })
})

