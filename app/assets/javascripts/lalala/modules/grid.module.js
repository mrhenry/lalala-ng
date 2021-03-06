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
    this.selected_assets = [];

    this.transform_html(grid_element);
    this.bind_mouse_events();
    this.setup_mouse_selection();
  }


  G.prototype.transform_html = function(grid_element) {
    var fragment, clear_element, el, el_assets, el_actions, el_errors,
        $grid, $original_list;

    // elements
    $grid = $(grid_element);
    $original_list = $grid.children("ul:first-child");

    // document fragment for the assets
    fragment = document.createDocumentFragment();

    // transform assets html
    $grid.find("li.asset").not(":last-child").each(function() {
      var grid_piece = document.createElement("li");
      grid_piece.className = "asset";
      grid_piece.innerHTML = this.innerHTML.replace("<a", "<a class=\"thumbnail\"");

      var overlay = document.createElement("div");
      overlay.className = "overlay";
      $(overlay).attr("title", $(this).attr("title"));

      grid_piece.appendChild(overlay);
      fragment.appendChild(grid_piece);
    });

    // create new container elements
    el = document.createElement("div");
    el.className = "mod-grid";

    clear_element = document.createElement("div");
    clear_element.className = "clear";

    el_assets = document.createElement("ul");
    el_assets.className = "assets";
    el_assets.appendChild(fragment);
    el_assets.appendChild(clear_element);

    el_actions = document.createElement("div");
    el_actions.className = "actions";
    el_actions.innerHTML = "" +
      $grid.find("li.actions").html() +
      '<a class="button" rel="choose-files">Choose files</a>' +
      '<div class="files-description"></div>' +
      '<a class="button unavailable" rel="edit">Edit selected</a>' +
      '<a class="button unavailable" rel="destroy">destroy selected</a>';

    // merge
    el.appendChild(el_actions);
    el.appendChild(el_assets);

    // errors
    if ($grid.find("li.errors").length) {
      el_errors = document.createElement("div");
      el_errors.className = "errors";
      el_errors.innerHTML = $grid.find("li.errors").html();
      el.appendChild(el_errors);
    }

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

      if (grid.selected_assets.length === 0) {
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
    this.$el.children(".assets")
      .on("mouseleave", "li", this.row_mouseleave)
      .on("mouseleave", "li label", this.row_label_mouseleave)
      .on("mouseenter", "li label", this.row_label_mouseenter)
      .on("mouseenter", "li .thumbnail", this.row_thumbnail_mouseenter)
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

  G.prototype.row_thumbnail_mouseenter = function(e) {
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
    var i = 0, j = this.selected_assets.length,
        $e = $(e.currentTarget), action = $e.attr("rel");

    if ($e.hasClass("unavailable")) return;

    for (; i<j; ++i) {
      var id = this.selected_assets[i];
      var $row = $("#" + id).parent();
      $row.removeClass("selected");
      this["set_to_" + action]($row[0]);
    }

    this.selected_assets.length = 0;
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
      filter: "li.asset",
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
        var new_selected_assets = [];
        grid.$el.find(".assets > li").each(function() {
          var $t = $(this), id;
          if ($t.hasClass("selected")) {
            id = $t.children('input[type="hidden"]:first').attr("id");
            new_selected_assets.push(id + "");
            id = null;
          }
        });
        grid.selected_assets = new_selected_assets;
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
