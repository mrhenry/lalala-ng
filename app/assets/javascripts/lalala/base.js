//= require active_admin/base
//= require_tree ./lib

//= require_tree ../browser
//= require_tree ./modules
//= require_tree ./initializers
//= require_self

var haraway = require("lalala/initializers/haraway");

$(function() {
  haraway.init();
});

// TODO - refactor
require('lalala/modules/init');
