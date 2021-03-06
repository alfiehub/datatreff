// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= jquery.turbolinks
//= require turbolinks
//= require jquery_ujs
//= require "jquery.countdown.js"
//= require "jquery-bracket"
//= require jquery.datetimepicker

var ready;
ready = function() {
  $('.datetimepicker').datetimepicker();

  $('.title').click(function(event) {
    event.preventDefault();
  });

  $("#clock").countdown("2017/09/22 16:00:00", {elapse: true}).on('update.countdown', function(event) {
    if (event.elapsed) {
      $(this).text(event.strftime("GalaxeLAN har begynt!"));
    } else {
      $(this).html(event.strftime('Bare <b>%-D</b> døgn, <b>%-H</b> %!H:time,timer;, <b>%-M</b> %!M:minutt,minutter; og <b>%-S</b> %!S:sekund,sekunder; igjen!'));
    };
  });
};

$(document).ready(ready);
$(window).on("load", ready);
