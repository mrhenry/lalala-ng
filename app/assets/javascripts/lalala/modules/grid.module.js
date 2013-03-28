var Grid;


exports.init = function() {
  var instances = [];
  this.$el = $(".grid");
  this.$el.each(function() { instances.push(new Grid(this)); });
};


Grid = (function() {
  var __bind = function(fn, me) {
    return function() { return fn.apply(me, arguments); };
  };


  function G(grid_element) {
    this.transform_html(grid_element);
    this.bind_mouse_events();
  }


  G.prototype.transform_html = function(grid_element) {
    var fragment, el, el_images, el_input, $grid;

    // document fragment for the images
    fragment = document.createDocumentFragment();

    // transform images html
    $grid = $(grid_element);
    $grid.find("li").not(":last-child").each(function() {
      var grid_piece = document.createElement("li");
      grid_piece.innerHTML = this.innerHTML.replace("<a", "<a class=\"image\"");
      var overlay = document.createElement("div");
      overlay.className = "overlay";
      grid_piece.appendChild(overlay);
      fragment.appendChild(grid_piece);
    });

    // create new container elements
    el = document.createElement("div");
    el.className = "mod-grid";
    el_images = document.createElement("ul");
    el_images.className = "images";
    el_images.appendChild(fragment);
    el_input = document.createElement("div");
    el_input.className = "input-fields";
    el_input.innerHTML = $grid.find("li:last-child").html();

    // merge
    el.appendChild(el_images);
    el.appendChild(el_input);

    // replace original with new
    $grid.children("ul:first-child").replaceWith(el);

    // bind to instance
    this.$el = $(el);
  };


  //
  //  Events
  //
  G.prototype.bind_mouse_events = function() {
    this.$el.children(".images")
      .on("mouseleave", "li", this.row_mouseleave)
      .on("mouseleave", "li label", this.row_label_mouseleave)
      .on("mouseenter", "li label", this.row_label_mouseenter)
      .on("mouseenter", "li .image", this.row_image_mouseenter)
      .on("click", "li .overlay", __bind(this.row_overlay_click, this));
  };

  G.prototype.row_mouseleave = function(e) {
    $(this).removeClass("properties");
  };

  G.prototype.row_label_mouseenter = function(e) {
    $(this).parent().addClass("move");
  };

  G.prototype.row_label_mouseleave = function(e) {
    $(this).parent().addClass("properties").removeClass("move");
  };

  G.prototype.row_image_mouseenter = function(e) {
    $(this).parent().addClass("properties");
  };

  G.prototype.row_overlay_click = function(e) {
    // $(this).parent().toggleClass("selected");
    this.toggle_destroy( $(e.currentTarget).parent()[0] );
  };



  //
  //  Destroy
  //
  G.prototype.toggle_destroy = function(row) {
    if ($(row).find('input[name$="[_destroy]"]').length) {
      this.set_to_not_destroy(row);
    } else {
      this.set_to_destroy(row);
    }
  };


  G.prototype.set_to_destroy = function(row) {
    var $row = $(row);
    var input_id_name = $row.find('input[name$="[id]"]')[0].name;
    var input_destroy = document.createElement("input");

    $(input_destroy).attr({
      name: input_id_name.replace("[id]", "[_destroy]"),
      type: "hidden",
      value: "1"
    });

    $row.append(input_destroy);
    $row.addClass("will-destroy");
  };


  G.prototype.set_to_not_destroy = function(row) {
    $(row).find('input[name$="[_destroy]"]').remove();
    $(row).removeClass("will-destroy");
  };



  //
  //  The end
  //
  return G;

})();
