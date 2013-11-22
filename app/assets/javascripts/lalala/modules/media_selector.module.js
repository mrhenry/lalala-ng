function MediaSelector() {
  this.$el = $('<div class="mod-media-selector" />');

  // settings
  this.settings = {
    selected_class: "selected"
  };

  // exec
  this.render();
  this.bind_events();
}



//
//  Render
//
MediaSelector.prototype.render = function() {
  var html, assets;

  // assets
  assets = "";

  for (var i=0, j=15; i<j; ++i) {
    assets = assets + '<div class="asset"><div class="image"></div></div>';
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
    ].join('')
  })()

};



//
//  Events
//
MediaSelector.prototype.bind_events = function() {
  this.$el.on("click", ".asset", $.proxy(this.asset_click_handler, this));
};


MediaSelector.prototype.asset_click_handler = function(e) {
  var $asset = $(e.currentTarget);

  if ($asset.hasClass(this.settings.selected_class)) {
    this.unselect_asset($asset);
  } else {
    this.select_asset($asset);
  }
};



//
//  Selecting assets
//
MediaSelector.prototype.select_asset = function($asset) {
  $asset.addClass(this.settings.selected_class);
};


MediaSelector.prototype.unselect_asset = function($asset) {
  $asset.removeClass(this.settings.selected_class);
};



//
//  -> EXPORT
//
module.exports = MediaSelector;
