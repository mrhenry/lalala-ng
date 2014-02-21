var Overlay = require("./overlay"),
    MediaSelector = require("./media_selector"),

    markdown_settings;


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
  $markitup_wrapper.find('.add-image').click(add_image_click_handler);
}



//
//  Fullscreen
//
function open_fullscreen(event) {
  var $markitup_wrapper = $(this).closest('.markItUp');
  $markitup_wrapper.find('.markItUpHeader .preview').trigger('mouseup');
  $markitup_wrapper.addClass('fullscreen');
}


function close_fullscreen(event) {
  var $markitup_wrapper = $(this).closest('.markItUp');
  $markitup_wrapper.removeClass('fullscreen');
}



//
//  Cheatsheet
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
//  Images
//
function add_image_click_handler(e) {
  var ms, overlay;

  ms = new MediaSelector();
  ms.$markitup_container = $(e.currentTarget).closest(".markItUpContainer");

  overlay = Overlay.get_instance();
  overlay.append_content(ms.$el);
  overlay.show("media-selector");
}



//
//  Mark It Up settings
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
    { name: 'Add table', openWith: '| ', closeWith: ' | column header |\n| ------------- | ------------- |\n|               |               |', placeHolder: 'Column header', className: 'add-table', multiline: true },
    { separator: '---' },
    { name: 'Link', key: 'L', openWith: '[[![Link text]!]', closeWith: ']([![Url:!:http://]!])', className: 'add-link' },
    { name: 'Image', className: 'add-image' },
    { separator: '---' },
    { name: 'Preview', call: 'preview', className: "preview" },
    { name: 'Fullscreen', className: 'fullscreen' },
    { name: 'Close fullscreen', className: 'close-fullscreen' },
    { separator: '---' },
    { name: 'Markdown cheatsheet', className: 'markdown-cheatsheet' }
  ]
};
