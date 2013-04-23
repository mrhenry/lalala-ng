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
    this.selected_images = [];

    this.transform_html(grid_element);
    this.bind_mouse_events();
    this.setup_mouse_selection();
  }


  G.prototype.transform_html = function(grid_element) {
    var fragment, el, el_images, el_input, data_attr, $grid, $original_list;

    // elements
    $grid = $(grid_element);
    $original_list = $grid.children("ul:first-child");

    // data -> attributes
    data_attr = "data-accessible-attributes";
    data_attr = $original_list.attr(data_attr)
    data_attr = data_attr ? data_attr.split(",") : [];

    // document fragment for the images
    fragment = document.createDocumentFragment();

    // transform images html
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

    el_actions = document.createElement("div");
    el_actions.className = "actions";
    el_actions.innerHTML = "" +
      $grid.find("li:last-child").html() +
      '<a class="button" rel="choose-files">Choose files</a>' +
      '<div class="files-description"></div>' +
      '<a class="button unavailable" rel="edit">Edit selected</a>' +
      '<a class="button unavailable" rel="destroy">destroy selected</a>';

    // merge
    el.appendChild(el_actions);
    el.appendChild(el_images);

    // replace original with new
    $original_list.replaceWith(el);

    // bind to instance
    this.$el = $(el);

    // other layout stuff
    this.$el.closest(".inputs").addClass("next");
  };


  G.prototype.check_edit_and_destroy_buttons = function() {
    var grid = this;

    this.$el.children(".actions").find('[rel="edit"], [rel="destroy"]').each(function() {
      var $btn = $(this);

      if (grid.selected_images.length === 0) {
        $btn.addClass("unavailable");
      } else {
        $btn.removeClass("unavailable");
      }
    });
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
      .on("click", "li a", function(e) { e.preventDefault(); })
      .on("click", "li .attributes .close-button", this.close_button_click);

    this.$el.children(".actions")
      .children("a[rel=\"choose-files\"]").on("click", this.choose_files_button_click).end()
      .children("input[type=\"file\"]").on("change", this.file_input_change).trigger("change").end()
      .children("a[rel=\"edit\"]").on("click", __bind(this.edit_or_destroy_selected_button_click, this)).end()
      .children("a[rel=\"destroy\"]").on("click", __bind(this.edit_or_destroy_selected_button_click, this));
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
    var $p = $(this).parent();
    if ($p.hasClass("edit-block")) return;
    $p.addClass("properties");
  };

  G.prototype.choose_files_button_click = function(e) {
    $(this).parent().children("input[type=\"file\"]").trigger("click");
  };

  G.prototype.file_input_change = function(e) {
    var val = this.files || $(this).val();
    var $fd = $(this).parent().children(".files-description");

    if (typeof val === "object") {
      val = val.length;
      $fd[0].innerHTML = val + " file" + (val === 1 ? "" : "s") + " chosen";
      $fd.show();
    }
  };

  G.prototype.edit_or_destroy_selected_button_click = function(e) {
    var i = 0, j = this.selected_images.length,
        $e = $(e.currentTarget), action = $e.attr("rel");

    if ($e.hasClass("unavailable")) return;

    for (; i<j; ++i) {
      var id = this.selected_images[i];
      var $row = $("#" + id).parent();
      $row.removeClass("selected");
      this["set_to_" + action]($row[0]);
    }

    this.selected_images.length = 0;
    this.check_edit_and_destroy_buttons();
  };

  G.prototype.close_button_click = function(e) {
    $(this).closest("li").removeClass("edit-block");
  };



  //
  //  Mouse selection
  //
  G.prototype.setup_mouse_selection = function() {
    var grid = this;

    this.$el.selectable({
      filter: "li",
      cancel: ".actions,.button,input,textarea,button",
      selecting: function(e, ui) {
        $row = $(ui.selecting);
        if (!$row.hasClass("will-destroy") && !$row.hasClass("edit-block")) {
          $row.addClass("selected");
        }
      },
      unselecting: function(e, ui) {
        $(ui.unselecting).removeClass("selected");
      },
      stop: function(e, ui) {
        var new_selected_images = [];
        grid.$el.find(".images > li").each(function() {
          var $t = $(this), id;
          if ($t.hasClass("selected")) {
            id = $t.children('input[type="hidden"]:first').attr("id");
            new_selected_images.push(id + "");
            id = null;
          }
        });
        grid.selected_images = new_selected_images;
        grid.check_edit_and_destroy_buttons();
      }
    });
  };



  //
  //  Edit
  //
  G.prototype.toggle_edit = function(row) {
    if ($(row).hasClass("edit-block")) {
      this.set_to_not_edit(row);
    } else {
      this.set_to_edit(row);
    }
  };


  G.prototype.set_to_edit = function(row) {
    $(row).addClass("edit-block");
  };


  G.prototype.set_to_not_edit = function(row) {
    $(row).removeClass("edit-block");
  }



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
