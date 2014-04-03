var FileMetadata = require("lalala/modules/file-metadata"),
    Overlay = require("lalala/modules/overlay");



function MultipleFilesUploader(xfiles_element) {
  this.$el = $(xfiles_element);
  this.$file_container = this.$el.find(".file-container");
  this.$form = this.$el.closest("form");

  this.state = {
    files: {},
    files_counter: 0
  };

  this.render_isempty_message_if_needed();
  this.make_xfile_template();
  this.make_items_sortable();
  this.show_amount_of_files();
  this.remove_hidden_fields_from_checkboxes(this.$file_container);
  this.bind_events();
}



//
//  Templates, views, etc.
//
MultipleFilesUploader.prototype.make_xfile_template = function() {
  var $template = this.$el.find("template.x-file-template");
  var template = $template.get(0);
  var $wrapper = $("<x-file />");
  var $content;

  if (template) {
    if (template.content) {
      $content = $(template.content.children);
      $wrapper.append($content);
    } else {
      $content = $.trim($template.html());
      $wrapper.append($content);
    }

    $template.remove();
    this.xfile_template = $wrapper.get(0);

  } else {
    this.xfile_template = null;

  }
};


MultipleFilesUploader.prototype.render_isempty_message_if_needed = function() {
  if (this.$file_container.find("x-file").length === 0) {
    this.$file_container[0].innerHTML = [
      "<div class=\"is-empty\">",
        "<div class=\"message\">",
          "Browse or drag files in here...",
        "</div>",
      "</div>"
    ].join("");

    this.set_data_inspection_html("");
  }
};


MultipleFilesUploader.prototype.set_data_inspection_html = function(html) {
  this.$el.find("header .data-inspection").html(html);
};


MultipleFilesUploader.prototype.clear_file_container = function() {
  this.$file_container.empty();
  this.$file_container.append("<div class=\"inner-wrapper\" />");
};


MultipleFilesUploader.prototype.show_amount_of_files = function() {
  var amount_of_files = this.$file_container.find("x-file").length;
  var word = (amount_of_files === 1 ? "file" : "files");

  this.set_data_inspection_html(
    amount_of_files + " " + word
  );
};


MultipleFilesUploader.prototype.remove_hidden_fields_from_checkboxes = function($element) {
  $element.find("input[type=\"checkbox\"]").each(function() {
    var name = $(this).attr("name");
    $element.find('[name="' + name + '"][type="hidden"]').remove();
  });
};



//
//  Handle file
//
MultipleFilesUploader.prototype.handle_file = function(file) {
  this.state.files_counter++;
  this.state.files[this.state.files_counter.toString()] = file;

  // element
  file.$el = $(this.xfile_template).clone();
  file.$el.attr("file-id", this.state.files_counter.toString());

  file.el = file.$el.get(0);

  // waiting class
  file.$el.addClass("waiting");

  // make thumbnail
  if (file.type.indexOf("image") == -1) {
    var fake_thumb = document.createElement("div");
    fake_thumb.className = "thumb no-image";
    file.el.insertBefore(fake_thumb, file.el.firstChild);

  } else {
    file.readThumbnailData(158, 110, function(canvas) {
      file.el.insertBefore(canvas, file.el.firstChild);
    });

  }

  // if there are no files yet in the file container, empty it.
  // this is done to remove messages, etc.
  if (this.$file_container.find("x-file").length === 0) {
    this.clear_file_container();
  }

  // add file element to dom
  this.$file_container.children(".inner-wrapper").append(file.el);

  // data inspection
  this.show_amount_of_files();

  // bind events
  file.on("start", this.file_start_handler);
  file.on("progress", this.file_progess_handler);
  file.on("err", this.file_err_handler);
  file.on("done:uploading", this.file_done_uploading_handler);
  file.on("done:processing", this.file_done_processing_handler);
  file.on("done", this.file_done_handler);
};



//
//  Events - File handlers
//
//  -> this = file
//
MultipleFilesUploader.prototype.file_start_handler = function(e) {
  this.$el.removeClass("waiting");
  this.$el.addClass("uploading");
};


MultipleFilesUploader.prototype.file_progess_handler = function(e) {
  if (this.$el.hasClass("error")) return;

  // if there are no transform -> upload percentage
  if (this.transforms === 0) {
    this.$el.find(".upload-bar").css("width", this.upload_percentage + "%");

  // if there are -> transform percentage
  } else {
    this.$el.find(".process-bar").css("width", this.transforms_percentage + "%");

  }
};


MultipleFilesUploader.prototype.file_err_handler = function(e) {
  console.error("Error", this);

  this.$el.addClass("error");
  this.$el.find(".upload-bar").css("width", "100%");
  this.$el.find(".process-bar").css("width", "100%");
};


MultipleFilesUploader.prototype.file_done_uploading_handler = function(e) {
  this.$el.find(".upload-bar").addClass("done");
  this.$el.removeClass("uploading");
  this.$el.addClass("processing");
};


MultipleFilesUploader.prototype.file_done_processing_handler = function(e) {
  this.$el.find(".process-bar").addClass("done");
};


MultipleFilesUploader.prototype.file_done_handler = function(e) {
  var name = this.$el.closest("x-files").attr("name");
  var pairs = format_asset_metadata(this.metadata, name + "[]");

  for (var i in pairs) {
    var input = document.createElement("input");
    input.type = "hidden";
    input.name = pairs[i].name;
    input.value = pairs[i].value;
    this.el.appendChild(input);
  }

  this.$el.removeClass("processing");
  this.$el.addClass("uploaded");

  // title
  this.$el.find(".title").html(this.metadata.file_name);

  // attr
  var id = this.$el.find("input[name$=\"[id]\"]").val();
  if (id) this.$el.attr("data-src-original", "//c.assets.sh/" + id + "/thumb");
};



//
//  Events - General
//
MultipleFilesUploader.prototype.bind_events = function() {
  var choose_handler  = $.proxy(this.choose_click_handler, this);
  var delete_handler  = $.proxy(this.xfile_btn_delete_click_handler, this);
  var meta_handler    = $.proxy(this.xfile_btn_meta_click_handler, this);

  this.$el.on("click", ".choose", choose_handler);
  this.$el.on("click", "x-file [data-action=\"delete\"]", delete_handler);
  this.$el.on("click", "x-file [data-action=\"meta\"]", meta_handler);

  // when processing/uploading files -> disable form
  Haraway.on("busy", $.proxy(function() {
    this.$form.on("submit", this.defer_submit);
  }, this));

  // when not processing/uploading files -> resume default behaviour
  Haraway.on("idle", $.proxy(function() {
    this.$form.off("submit", this.defer_submit);
  }, this));
};


MultipleFilesUploader.prototype.choose_click_handler = function(e) {
  var accept = this.$el.attr("accept").split(",");
  var profile = this.$el.attr("profile");

  // prevent default
  e.preventDefault();

  // show choose dialog
  Haraway.choose(accept, true, profile, $.proxy(this.handle_file, this));
};


MultipleFilesUploader.prototype.defer_submit = function(e) {
  var $form = $(e.currentTarget);

  // prevent default behaviour
  e.preventDefault();

  // disable submit button
  $form.find("input[type=\"submit\"]").attr("disabled", "disabled");

  // once processing/uploading is complete
  // enable submit button and submit form
  Haraway.once("idle", function() {
    $form.find("input[type=submit]").attr("disabled", null);
    $form.submit();
  });
};


MultipleFilesUploader.prototype.xfile_btn_delete_click_handler = function(e) {
  var $xfile = $(e.currentTarget).closest("x-file");
  if ($xfile.length) this.toggle_destroy($xfile);
};


MultipleFilesUploader.prototype.xfile_btn_meta_click_handler = function(e) {
  var $xfile = $(e.currentTarget).closest("x-file"), fum;
  var main_overlay = Overlay.get_instance();

  // check status, must be uploaded file
  if (!$xfile.hasClass("uploaded")) return;

  // new metadata overlay-content block
  fum = new FileMetadata($xfile, this);
  main_overlay.append_content(fum.$el);
  main_overlay.$el.find("select").chosen({ width: "80%" });
  main_overlay.show("file-metadata");
};



//
//  Destroy
//
MultipleFilesUploader.prototype.toggle_destroy = function($xfile) {
  if ($xfile.hasClass("about-to-destroy")) {
    this.set_to_not_destroy($xfile);
  } else {
    this.set_to_destroy($xfile);
  }
};


MultipleFilesUploader.prototype.set_to_destroy = function($xfile) {
  var $destroy, $id;

  // add class
  $xfile.addClass("about-to-destroy");

  // input
  $destroy = $xfile.find("[name$=\"_destroy]\"]");

  if ($destroy.length === 0) {
    $id = $xfile.find("[name$=\"[id]\"]");
    $destroy = $("<input />");
    $destroy.attr("type", "hidden");
    $destroy.attr("name", $id.attr("name").replace("id", "_destroy"));
    $id.after($destroy);
  }

  // set
  $destroy.attr("value", "1");
};


MultipleFilesUploader.prototype.set_to_not_destroy = function($xfile) {
  $xfile.removeClass("about-to-destroy");
  $xfile.find("[name$=\"_destroy]\"]").attr("value", "0");
};



//
//  Sortable
//
MultipleFilesUploader.prototype.make_items_sortable = function() {
  this.$el.sortable({
    containment: "parent",
    items: "x-file",
    handle: "[data-action=\"move\"]"
  });
};



//
//  Extra's
//
function format_asset_metadata(value, prefix) {
  var results = [], i;

  if (value instanceof Array) {
    for (i in value) {
      results = results.concat(format_asset_metadata(value[i], prefix + "[]"));
    }
    return results;
  }

  if (value === Object(value)) {
    for (i in value) {
      if (value.hasOwnProperty(i)) {
        results = results.concat(format_asset_metadata(value[i], prefix + "[" + i + "]"));
      }
    }
    return results;
  }

  return [{ name: prefix, value: value }];
}



//
//  -> EXPORT
//
module.exports = MultipleFilesUploader;
