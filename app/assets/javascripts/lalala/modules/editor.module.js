var markdown_settings;

exports.init = function(){
  $("textarea.markdown").each(setup);
};

function setup() {
  var $this    = $(this);
  var settings = $.extend({}, markdown_settings);

  settings.previewParserVar = $this.attr("name");
  $this.markItUp(settings);

  var $markitup_wrapper = $this.closest('.markItUp');
  $markitup_wrapper.find('.fullscreen').click(open_fullscreen);
  $markitup_wrapper.find('.close-fullscreen').click(close_fullscreen);
  $markitup_wrapper.find('.markdown-cheatsheet').click(toggle_cheatsheet);
}

//
// Go fullscreen
//
function open_fullscreen(event) {
  var $markitup_wrapper = $(this).closest('.markItUp');
  $markitup_wrapper.find('.markItUpHeader .preview').trigger('mouseup');
  $markitup_wrapper.addClass('fullscreen');
}

//
// Close fullscreen
//
function close_fullscreen(event) {
  var $markitup_wrapper = $(this).closest('.markItUp');
  $markitup_wrapper.removeClass('fullscreen');
}

//
// Toggle Markdown cheatsheet
//
function toggle_cheatsheet(event) {
  var $markdown_cheatsheet = $('#markdown-cheatsheet');

  // cheatsheet is not yeat loaded
  if ($markdown_cheatsheet.length === 0) {
    load_cheatsheat({ open: true });
    return;
  }

  if ( $markdown_cheatsheet.is(':visible') ) {
    $markdown_cheatsheet.fadeOut(300);

  } else {
    $markdown_cheatsheet.fadeIn(300);

  }
}

//
// Load Markdown syntax cheatsheet
//
function load_cheatsheat(options) {
  $.get('/lalala/markdown/cheatsheet', function(data) {
    var $div = $('<div id="markdown-cheatsheet" />');

    $div
      .html( data )
      .hide();

    $div.appendTo('body');

    if (options && options.open) {
      toggle_cheatsheet();
    }
  });
}

//
// Mark It Up settings
//
var base_path = window.location.pathname.replace(/[\/][^\/]+$/, "");

markdown_settings = {
  nameSpace:          'markdown-editor', // Useful to prevent multi-instances CSS conflict
  previewParserPath:  base_path + '/preview',
  onShiftEnter:       { keepDefault: false, openWith:'\n\n' },
  markupSet: [
    { name: 'Heading 2', key: '2', openWith: '## ', placeHolder: 'Your title here...', className: 'h2' },
    { name: 'Heading 3', key: '3', openWith: '### ', placeHolder: 'Your title here...', className: 'h3' },
    { name: 'Heading 4', key: '4', openWith: '#### ', placeHolder: 'Your title here...', className: 'h4' },
    { separator: '---' },
    { name: 'Bold', key: 'B', openWith: '**', closeWith: '**', className: 'bold' },
    { name: 'Italic', key: 'I', openWith: '_', closeWith: '_', className: 'italic' },
    { separator: '---' },
    { name: 'Unordered list', openWith: '- ', className: 'unordered-list', multiline: true },
    { name: 'Ordered list', openWith: '1. ', closeWith: '\n2. \n3. ', className: 'ordered-list', multiline: true },
    /*
| column header |\n| ------------- | ------------- |\n|               |               |
    */
    { name: 'Add table', openWith: '| ', closeWith: ' | column header |\n| ------------- | ------------- |\n|               |               |', placeHolder: 'Column header', className: 'add-table', multiline: true },
    { separator: '---' },
    { name: 'Link', key: 'L', openWith: '[[![Link text]!]', closeWith: ']([![Url:!:http://]!])', className: 'add-link' },
    //{ name: 'Image', openWith: '![[![Alternative text]!]]', closeWith: '([![Url:!:http://]!] "[![Image title]!]")', className: 'add-image' },
    { separator: '---' },
    { name: 'Preview', call: 'preview', className: "preview" },
    { name: 'Fullscreen', className: 'fullscreen' },
    { name: 'Close fullscreen', className: 'close-fullscreen' },
    { separator: '---' },
    { name: 'Markdown cheatsheet', className: 'markdown-cheatsheet' }
  ]
};
