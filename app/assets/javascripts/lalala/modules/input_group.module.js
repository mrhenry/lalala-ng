'use strict';

exports.init = function () {
  $('.js-prepend-placeholder[placeholder], .js-append-placeholder[placeholder]').each(function () {
    var $this = $(this);
    replace_input_with_group($this, $this.attr('placeholder'), $this.hasClass('js-append-placeholder'));
  });
}

function replace_input_with_group ($input, placeholder, reverse) {
    var placeholder  = placeholder || '',
        reverse      = (typeof reverse === 'undefined') ? false : reverse,
        span_class   = !!reverse ? 'input-append' : 'input-prepend',
        $clone       = $input.clone(),
        $input_group = $('<div class="input-group"></div>'),
        $prepend     = $('<span class="' + span_class + '">' + placeholder + '</span>');

    $prepend.prependTo($input_group);
    $clone.attr('placeholder', '')
          .appendTo($input_group);
    $input.replaceWith($input_group);
    $clone.css(!!reverse ? 'padding-right' : 'padding-left', (parseInt($clone.css('padding-right'), 10) + parseInt($prepend.outerWidth(), 10)) + 'px');
}