var Overlay = require("./overlay");


function MediaSelector() {
  this.$el = $('<div class="mod-media-selector" />');

  // settings
  this.settings = {
    selected_class: "selected",
    selected_data: "SELF"
  };

  // data
  this.data_store = {};
  this.selected_uuids = [];

  // exec
  this.fetch_and_render();
  this.bind_events();
}



//
//  Data & Render
//
MediaSelector.prototype.fetch_data_if_needed = function(klass, id, association) {
  var url = "/lalala/assets/list";
  var dfd = $.Deferred();
  var request_data, data_key, data_store;

  // prepare request data to send along
  if (klass && id && association) {
    request_data = "klass=" + klass + "&id=" + id + "&association=" + association;
  } else {
    request_data = "";
  }

  // data store
  data_key = klass ? klass : "all";
  data_store = this.data_store;

  // request & resolve
  if (!data_store[data_key]) {
    return $.getJSON(url, request_data, function(response) {
      data_store[data_key] = response;
      dfd.resolve(data_store[data_key]);
    });

  } else {
    dfd.resolve(data_store[data_key]);

  }

  // promise
  return dfd.promise();
};


MediaSelector.prototype.fetch_and_render = function() {
  var fetch_args;

  // fetch arguments
  switch (this.settings.selected_data) {
    case "SELF":
      // TODO
      fetch_args = ["Article", "1", "images"];
      break;

    case "ALL":
      fetch_args = [];
      break;
  }

  // fetch -> render
  this.fetch_data_if_needed.apply(this, fetch_args).then(
    $.proxy(this.render, this)
  );
};


MediaSelector.prototype.render = function(data) {
  var html, assets;

  // assets
  assets = "";

  for (var i=0, j=data.length; i<j; ++i) {
    var asset = data[i];
    assets = assets + '<div class="asset" rel="' + asset.uuid + '">' +
      '<div class="image" style="background-image: url(\'' + asset.url + '\');"></div>' +
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
  var uuid = $asset.attr("rel");

  // add to 'selected' array
  this.selected_uuids.push(uuid);

  // visual
  $asset.addClass(this.settings.selected_class);
};


MediaSelector.prototype.unselect_asset = function($asset) {
  var uuid = $asset.attr("rel");
  var index = this.selected_uuids.indexOf(uuid);

  // remove from 'selected' array
  if (index !== -1) {
    this.selected_uuids.splice(index, 1);
  }

  // visual
  $asset.removeClass(this.settings.selected_class);
};


MediaSelector.prototype.add_selected_to_editor_textarea = function() {
  var selected = this.selected_uuids;
  var markdown = "";
  var $textarea;

  // build markdown text
  for (var i=0, j=selected.length; i<j; ++i) {
    markdown = markdown + "{{haraway/" + selected[i] + "}}  \n";
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
