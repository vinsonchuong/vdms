// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var checkboxes = [];
checkboxes = $$('input').each(function(e){ if(e.type == 'checkbox') checkboxes.push(e) });
var form = $('options'); /* Replace 'options' with the ID of the FORM element */
checkboxes = form.getInputs('checkbox');