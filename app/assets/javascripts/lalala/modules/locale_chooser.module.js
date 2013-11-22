var storage = require("lalala/modules/storage"),
    $chooser;


exports.init = function(){
  $chooser = $('.locale_chooser select').first();

  if ($chooser.length > 0) {
    setup();
  }
};


function setup() {
  var locale = storage.locale,
      default_locale;

  if (!locale) {
    locale = "__EMPTY__";
  }

  if ($chooser.find('option[value='+locale+']').length === 0) {
    locale = "__EMPTY__";
  }

  if (locale == "__EMPTY__") {
    default_locale = $chooser.find('option[data-default]').first();
    if (default_locale.length === 0) {
      default_locale = $chooser.find('option').first();
    }
    locale = default_locale.attr('value');
  }

  switch_locale(locale);

  $chooser.val(locale);
  $chooser.on('change', on_switch_locale);
}


function on_switch_locale(e) {
  switch_locale($(this).val());
}


function switch_locale(locale) {
  var translated = $(".translated[data-locale]"),
      current    = translated.filter("*[data-locale="+locale+"]"),
      other      = translated.not(current);

  other.hide();
  current.show();

  storage.locale = locale;
}
