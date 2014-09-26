var console = require('browser/console'),
    calendar = require('lalala/modules/calendar'),
    editor = require('lalala/modules/editor'),
    grid = require('lalala/modules/grid'),
    locale_chooser = require("lalala/modules/locale_chooser"),
    sorted_pages_tree = require("lalala/modules/sorted_pages_tree"),
    login = require("lalala/modules/login"),
    dashboard = require("lalala/modules/dashboard"),
    collapsible_pages_tree = require("lalala/modules/collapsible_pages_tree"),
    input_group = require("lalala/modules/input_group");

$(function() {
  login.init();
  locale_chooser.init();
  editor.init();
  calendar.init();
  grid.init();
  sorted_pages_tree.init();
  dashboard.init();
  collapsible_pages_tree.init();
  input_group.init();

  $('select').not(".bypass-chosen").chosen();
});
