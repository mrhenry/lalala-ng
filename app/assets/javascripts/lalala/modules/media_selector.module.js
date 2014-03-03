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
  this.last_rendered_data = [];

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

  // versions
  this.setup_version_option();
};


MediaSelector.prototype.collect_data_from_self = function() {
  var data = [];

  $("x-files[accept*=\"image\"]").each(function() {
    var $xfiles = $(this);
    var versions;

    versions = $xfiles.find(".meta-versions .version").map(function() {
      return $(this).attr("data-name");
    }).toArray();

    $xfiles.find("x-file[data-src-original]").each(function() {
      var $xfile = $(this);

      data.push({
        id: $xfile.find("[name$=\"[id]\"]").attr("value"),
        thumb_url: $xfile.attr("data-src-original").replace(/original$/, "thumb"),
        versions: versions
      });
    });
  });

  return data;
};


MediaSelector.prototype.render = function(data) {
  var html, assets;

  // store data
  this.last_rendered_data = data;

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
        '<div class="data-selection">Insert image</div>',
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

        '<div class="options">',
          '<div class="options-title">Options</div>',
          '<div class="version"></div>',
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
  var version = this.$el.find(".options .version select option:selected").val() || "original";
  var markdown = "";
  var $textarea;

  // build markdown text
  for (var i=0, j=selected.length; i<j; ++i) {
    markdown = markdown + "![](asset://" + selected[i] + "/" + version + ")  \n";
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
//  Options
//
MediaSelector.prototype.setup_version_option = function() {
  var versions = [];
  var select_element;

  // collect all versions
  for (var i=0, j=this.last_rendered_data.length; i<j; ++i) {
    var data_piece = this.last_rendered_data[i];

    for (var k=0, l=data_piece.versions.length; k<l; ++k) {
      var version = data_piece.versions[k];
      if (versions.indexOf(version) === -1) {
        versions.push(version)
      }
    }
  }

  // make option element
  select_element = document.createElement("select");
  select_element.innerHTML = $.map(["original"].concat(versions), function(v) {
    return "<option value=\"" + v + "\">" + v + "</option>";
  }).join("");

  // add to dom & apply chosen
  this.$el.find(".options .version")
    .empty()
    .append(select_element)
    .children("select")
    .chosen({ width: "100%" });
};



//
//  -> EXPORT
//
module.exports = MediaSelector;
