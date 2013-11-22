var Helpers = require("./helpers");



function Login(el) {
  this.$el = $(el);
  this.$tryout = this.$el.find(".text.tryout");

  this.bind_events();
  this.$el.find("input").trigger("change");
}



//
//  Events
//
Login.prototype.bind_events = function() {
  this.$el.on("change", "input", $.proxy(this.input_change_handler, this));
  this.$el.on("keyup", "input", Helpers.debounce($.proxy(this.input_keyup_handler, this), 250));
};


Login.prototype.input_change_handler = function(e) {
  var $trgt, text, width;

  // input element
  $trgt = $(e.currentTarget);

  // text
  text = $trgt.val();

  if ($trgt.attr("type") == "password") {
    text = new Array(text.length + 1).join("⦁");
  }

  this.$tryout.text(text);

  // width
  if (!e.currentTarget.original_width) {
    e.currentTarget.original_width = $trgt.width();
  }

  width = this.$tryout.width();
  if (width < e.currentTarget.original_width) {
    width = e.currentTarget.original_width;
  }

  $trgt.width(width);
};


Login.prototype.input_keyup_handler = function(e) {
  $(e.currentTarget).trigger("change");
};



//
//  Exports
//
exports.init = function() {
  $(".mod-login").each(function() {
    new Login(this);
  });
};
