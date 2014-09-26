//= require active_admin/base
//= require_tree ./lib
//= require_tree ../browser
//= require_tree ./modules
//= require_tree ./initializers
//= require_self

$(function() {
  var initializers = [
    "assets", "chosen"
  ];

  var modules = [
    "calendar", "editor", "locale_chooser",
    "sorted_pages_tree", "login", "dashboard",
    "collapsible_pages_tree", "input_group"
  ];

  for (var i=0, j=initializers.length; i<j; ++i) {
    require("lalala/initializers/" + initializers[i]).init();
  }

  for (var m=0, n=modules.length; m<n; ++m) {
    require("lalala/modules/" + modules[m]).init();
  }
});
