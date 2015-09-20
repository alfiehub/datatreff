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
//= require bootstrap/dist/js/bootstrap
//= require metisMenu/dist/metisMenu
//= require sb-admin-2

var ready;
ready = function() {
  $(function() {
    $('.datetimepicker').datetimepicker();
  });

  $(function() {
    $("#clock").countdown("2015/09/18 16:00:00", {elapse: true}).on('update.countdown', function(event) {
      if (event.elapsed) {
      $(this).text(event.strftime("GalaxeLAN er over for denne gang :'( Nedtelling til neste GalaxeLAN kommer!"));
      } else {
      $(this).html(event.strftime('Bare <b>%-D</b> døgn, <b>%-H</b> %!H:time,timer;, <b>%-M</b> %!M:minutt,minutter; og <b>%-S</b> %!S:sekund,sekunder; igjen!'));
      };
    });
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
