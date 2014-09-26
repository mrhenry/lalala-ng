'use strict';

/**
 * Append or prepend placeholders to certain inputs
 */

exports.init = function () {
  $('.js-prepend-placeholder[placeholder], .js-append-placeholder[placeholder]').each(function () {
    var $this = $(this);
    replace_input_with_group($this, $this.attr('placeholder'), $this.hasClass('js-append-placeholder'));
  });
}

/**
 * Replace an <input> element with an appended/prepended placeholder
 * @param  {jQuery}          $input
 * @param  {string}          placeholder
 * @param  {optional} {bool} reverse - false: prepend, true: append (default false)
 * @return {jQuery}          The new input group
 */
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

    return $input_group;
}