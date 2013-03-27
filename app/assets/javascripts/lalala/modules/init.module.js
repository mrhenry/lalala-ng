var console = require('browser/console'),
    calendar = require('lalala/modules/calendar'),
    editor = require('lalala/modules/editor'),
    locale_chooser = require("lalala/modules/locale_chooser");

$(function(){
  locale_chooser.init();
  editor.init();
  calendar.init();

  $('select').chosen();
});
