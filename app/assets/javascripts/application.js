//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require lib
//= require vendor
//= require hamlcoffee
//= require app

var afterRender =  function() {
  $('a.action, button').button();
};
$(afterRender);
