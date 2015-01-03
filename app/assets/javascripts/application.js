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
        }
      })
    }
  })
})

