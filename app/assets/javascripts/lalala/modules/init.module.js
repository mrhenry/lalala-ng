var console        = require('browser/console'),
    locale_chooser = require("lalala/modules/locale_chooser"),
    editor         = require("lalala/modules/editor");

$(function(){
  locale_chooser.init();

  $('select').chosen();
  editor.init();
});
