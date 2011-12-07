//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require lib
//= require vendor
//= require hamlcoffee
//= require app

var
  afterRender =  function() {
    $('a.action, button').button();
    $('input.location').each(function() {
      new google.maps.places.Autocomplete(this);
    });
  },
  showSpinner = function() {
    $('body').append($('<div class="ui-widget-overlay"></div>'));
    $('body').spin({lines: 8, length: 24, width: 12, radius: 18, trail: 50, speed: 1, shadow: true, color: '#ff932b'});
  },
  hideSpinner = function() {
    $('body').spin(false);
    $('.ui-widget-overlay').remove();
  }
;
$(afterRender);
