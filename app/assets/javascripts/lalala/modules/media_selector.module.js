var Overlay = require("./overlay");


function MediaSelector() {
  this.$el = $('<div class="mod-media-selector" />');

  // settings
  this.settings = {
    selected_class: "selected",
    selected_data: "SELF"
  };

  // data
  this.selected_ids = [];

  // exec
  this.collect_data_and_render();
  this.bind_events();
}



//
//  Data & Render
//
MediaSelector.prototype.collect_data_and_render = function() {
  var data;

  // fetch arguments
  switch (this.settings.selected_data) {
    case "SELF":
      data = this.collect_data_from_self();
      break;

    case "ALL":
      data = [];
      break;
  }

  // render
  this.render(data);
};


MediaSelector.prototype.collect_data_from_self = function() {
  var data = [];

  $("x-file").each(function() {
    var $xfile = $(this);

    data.push({
      id: $xfile.find("[name$=\"[id]\"]").attr("value"),
      thumb_url: $xfile.attr("data-src-original").replace(/original$/, "thumb")
    })
  });

  return data;
};


MediaSelector.prototype.render = function(data) {
  var html, assets;

  // assets
  assets = "";

  for (var i=0, j=data.length; i<j; ++i) {
    var asset = data[i];
    assets = assets + '<div class="asset" rel="' + asset.id + '">' +
      '<div class="image" style="background-image: url(\'' + asset.thumb_url + '\');"></div>' +
    '</div>';
  }

  // compose
  html = this.templates.main;
  html = html.replace("{{ASSETS}}", assets);

  // add to dom
  this.$el.html(html);
};



//
//  Templates
//
MediaSelector.prototype.templates = {

  main: (function() {
    return [
      '<header>',
        '<div class="data-selection"></div>',
        '<a class="close">✕</a>',
      '</header>',

      '<section>',
        '<div class="asset-container">{{ASSETS}}</div>',
      '</section>',

      '<aside>',
        '<div class="actions">',
          '<a class="button large commit">Add media to post</a>',
          '<a class="button large cancel close">Cancel</a>',
        '</div>',
      '</aside>'
    ].join('');
  })()

};



//
//  Events
//
MediaSelector.prototype.bind_events = function() {
  this.$el.on("click", ".asset", $.proxy(this.asset_click_handler, this));
  this.$el.on("click", ".actions .commit", $.proxy(this.commit_click_handler, this));
};


MediaSelector.prototype.asset_click_handler = function(e) {
  var $asset = $(e.currentTarget);

  if ($asset.hasClass(this.settings.selected_class)) {
    this.unselect_asset($asset);
  } else {
    this.select_asset($asset);
  }
};


MediaSelector.prototype.commit_click_handler = function(e) {
  this.add_selected_to_editor_textarea();
};



//
//  Selecting assets
//
MediaSelector.prototype.select_asset = function($asset) {
  var id = $asset.attr("rel");

  // add to 'selected' array
  this.selected_ids.push(id);

  // visual
  $asset.addClass(this.settings.selected_class);
};


MediaSelector.prototype.unselect_asset = function($asset) {
  var id = $asset.attr("rel");
  var index = this.selected_ids.indexOf(id);

  // remove from 'selected' array
  if (index !== -1) {
    this.selected_ids.splice(index, 1);
  }

  // visual
  $asset.removeClass(this.settings.selected_class);
};


MediaSelector.prototype.add_selected_to_editor_textarea = function() {
  var selected = this.selected_ids;
  var markdown = "";
  var $textarea;

  // build markdown text
  for (var i=0, j=selected.length; i<j; ++i) {
    markdown = markdown + "![](asset://" + selected[i] + ")  \n";
  }

  // add to textarea
  // TODO: save cursor position before opening overlay,
  //       then apply it again here
  $textarea = this.$markitup_container.find("textarea");
  $textarea.val($textarea.val() + markdown);

  // hide overlay
  Overlay.get_instance().hide();
};



//
//  -> EXPORT
//
module.exports = MediaSelector;
