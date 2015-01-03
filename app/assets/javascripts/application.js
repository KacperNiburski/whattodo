// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
// 
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

  $('#submit-all').click(function() {
    var allData = []
    $.each($('input:checked'), function(index, eventId) {
      var eventNum = $(eventId).val()
      allData.push(eventNum)
    })

    $.ajax({
      url: "/api/v1/approve",
      type: "GET",
      dataType: "script",
      data: {events: allData },
      complete: function(data) {
        console.log('complete')
      }
    })
  })
})

