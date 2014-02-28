var console = require('browser/console'),
    calendar = require('lalala/modules/calendar'),
    editor = require('lalala/modules/editor'),
    locale_chooser = require("lalala/modules/locale_chooser"),
    sorted_pages_tree = require("lalala/modules/sorted_pages_tree"),
    login = require("lalala/modules/login"),
    dashboard = require("lalala/modules/dashboard"),
    collapsible_pages_tree = require("lalala/modules/collapsible_pages_tree");

$(function() {
  login.init();
  locale_chooser.init();
  editor.init();
  calendar.init();
  sorted_pages_tree.init();
  dashboard.init();
  collapsible_pages_tree.init();

  $('select').not(".bypass-chosen").chosen();
});
