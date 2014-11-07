function SingleFileUploader(xfile_element) {
  this.$el = $(xfile_element);
  this.$form = this.$el.closest("form");

  this.bind_events();
}



//
//  Handle file
//
SingleFileUploader.prototype.handle_file = function(file) {
  var $image;

  file.$el = this.$el;
  file.el = file.$el.get(0);

  // make & add thumbnail
  image = file.$el.find(".content .image").get(0);
  image.innerHTML = "";

  if (file.type.indexOf("image") == -1) {
    var fake_thumb = document.createElement("div");
    fake_thumb.className = "thumb no-image";
    image.appendChild(fake_thumb);

  } else {
    file.readThumbnailData(58, 38, function(canvas) {
      image.appendChild(canvas);
    });

  }

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
SingleFileUploader.prototype.file_start_handler = function(e) {
  this.$el.removeClass("waiting");
  this.$el.addClass("uploading");
};


SingleFileUploader.prototype.file_progess_handler = function(e) {
  var $el = this.$el;

  // check
  if ($el.hasClass("error")) {
    return;
  }

  // if there are no transform -> upload percentage
  if (this.transforms === 0) {
    $el.find(".upload-bar").css("width", this.upload_percentage + "%");

  // if there are -> transform percentage
  } else {
    $el.find(".process-bar").css("width", this.transforms_percentage + "%");

  }
};


SingleFileUploader.prototype.file_err_handler = function(e) {
  console.error("Error", this);

  this.$el.addClass("error");
  this.$el.find(".upload-bar").css("width", "100%");
  this.$el.find(".process-bar").css("width", "100%");
};


SingleFileUploader.prototype.file_done_uploading_handler = function(e) {
  this.$el.find(".upload-bar").addClass("done");
  this.$el.removeClass("uploading");
  this.$el.addClass("processing");
};


SingleFileUploader.prototype.file_done_processing_handler = function(e) {
  this.$el.find(".process-bar").addClass("done");
};


SingleFileUploader.prototype.file_done_handler = function(e) {
  var name = this.$el.closest("x-files").attr("name");
  var pairs = format_asset_metadata(this.metadata, name);

  // remove any old inputs
  this.$el.find('input').remove();

  for (var i in pairs) {
    var input = document.createElement("input");
    input.type = "hidden";
    input.name = pairs[i].name;
    input.value = pairs[i].value;
    this.el.appendChild(input);
  }

  this.$el.removeClass("processing");
  this.$el.addClass("uploaded");
  this.$el.find(".content > .title > .name").html(this.metadata.file_name);
  this.$el.find(".actions").show();
};



//
//  Events - General
//
SingleFileUploader.prototype.bind_events = function() {
  // show the actions if there is file
  if (this.$el.find('.content > .title > .name').text().trim().length > 0) {
    this.$el.find(".actions").show();
  }

  var choose_handler = $.proxy(this.choose_click_handler, this);
  var delete_handler = $.proxy(this.delete_click_handler, this);

  this.$el.on("click", ".choose", choose_handler);
  this.$el.on("click", "[data-action]", delete_handler);

  // when processing/uploading files -> disable form
  Haraway.on("busy", $.proxy(function() {
    this.$form.on("submit", this.defer_submit);
  }, this));

  // when not processing/uploading files -> resume default behaviour
  Haraway.on("idle", $.proxy(function() {
    this.$form.off("submit", this.defer_submit);
  }, this));
};


SingleFileUploader.prototype.choose_click_handler = function(e) {
  var accept = this.$el.attr("accept").split(",");
  var profile = this.$el.attr("profile");

  // prevent default
  e.preventDefault();

  // show choose dialog
  Haraway.choose(accept, false, profile, $.proxy(this.handle_file, this));
};

SingleFileUploader.prototype.delete_click_handler = function(e) {
  e.preventDefault();

  this.$el.find(".actions").hide();

  this.$el.find('input').remove();

  var name = this.$el.closest("x-files").attr("name");
  var input = document.createElement("input");
  input.type = "hidden";
  input.name = name+"[_destroy]";
  input.value = "1";
  this.$el.append(input);
}


SingleFileUploader.prototype.defer_submit = function(e) {
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
module.exports = SingleFileUploader;
