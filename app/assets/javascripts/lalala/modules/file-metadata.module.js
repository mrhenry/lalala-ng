var Overlay = require("lalala/modules/overlay");



function FileMetadata($xfile, fileuploader) {
  this.$el = $('<div class="mod-file-metadata" />');
  this.$xfile = $xfile;
  this.fileuploader = fileuploader;

  this.render();
  this.bind_events();
}



FileMetadata.prototype.render = function() {
  var tmpl, main_tmpl, sidebar_tmpl, img_tmpl, meta_tmpl;
  var that = this;

  // main
  main_tmpl = this.main_template;
  main_tmpl = main_tmpl.replace("{{FIELDS}}",
    this.$xfile.find(".attributes").length ?
    this.$xfile.find(".attributes").html() :
    this.get_form_template()
  );

  // sidebar
  sidebar_tmpl = this.sidebar_template;

  if (this.$xfile.hasClass("saved-to-db")) {
    img_tmpl = '<a href="' + this.$xfile.attr("data-src-original").replace("original", "thumb") + '" class="image cover" style="display: block; background-image: url(' + this.$xfile.attr("data-src-original").replace("original", "thumb") + ');"></a>';

    meta_tmpl = this.$xfile.find(".meta").html();

  } else {
    img_tmpl = '<div class="image"><canvas></canvas></div>';
    meta_tmpl = '';

    this.$xfile.find("input")
      .filter("[name$=\"extension]\"]:first")
      .each(function() {
        var $t, name;

        $t = $(this);
        meta_tmpl += '<div class="row"><span class="label">';
        name = $t.attr("name");
        name = name.substring(name.lastIndexOf("[") + 1, name.lastIndexOf("]"));

        switch (name) {
          case "extension": meta_tmpl += 'filetype';
        }

        meta_tmpl += '</span><span class="value">' +
                       $t.attr("value") +
                     '</span></div>';
      });

  }

  sidebar_tmpl = sidebar_tmpl.replace("{{IMAGE}}", img_tmpl);
  sidebar_tmpl = sidebar_tmpl.replace("{{META}}", meta_tmpl);

  // global template
  tmpl = this.template;
  tmpl = tmpl.replace("{{MAIN}}", main_tmpl);
  tmpl = tmpl.replace("{{SIDEBAR}}", sidebar_tmpl);

  // add to dom
  this.$el.html(tmpl);

  // canvas clone
  this.$el.find("canvas").each(function() {
    var $canvas = $(this), file;
    var file_id = that.$xfile.attr("file-id");

    if (file_id) {
      file = that.fileuploader.state.files[file_id];

      if (file) {
        file.readThumbnailData(220, 153, function(canvas) {
          $canvas.replaceWith(canvas);
        });
      }
    }
  });
};



//
//  Templates
//
FileMetadata.prototype.template = (function() {
  return [
    '<div class="mod-file-metadata">',
      '<div class="main">{{MAIN}}</div>',
      '<div class="sidebar">{{SIDEBAR}}</div>',
    '</div>'
  ].join("");
})();


FileMetadata.prototype.main_template = (function() {
  return [
    '<div class="fields">',
      '{{FIELDS}}',
    '</div>'
  ].join("");
})();


FileMetadata.prototype.sidebar_template = (function() {
  return [
    '{{IMAGE}}',
    '<div class="meta">{{META}}</div>',
    '<div class="actions">',
      '<a class="button commit">Update meta data</a>',
      '<a class="button cancel">Cancel</a>',
    '</div>'
  ].join("");
})();


FileMetadata.prototype.get_form_template = function() {
  var $x = this.fileuploader.$el.find("template.form-template");
  var x = $x.get(0);
  var wrapper = document.createElement("div");

  if (x.content) {
    $(wrapper).append( $(x.content.children).clone() );
  } else {
    $(wrapper).append( $x.clone().html() );
  }

  return wrapper.innerHTML;
};



//
//  Events (General)
//
FileMetadata.prototype.bind_events = function() {
  this.$el.on("click", "a.button.commit", $.proxy(this.commit_click_handler, this));
  this.$el.on("click", "a.button.cancel", $.proxy(this.cancel_click_handler, this));
};


FileMetadata.prototype.unbind_events = function() {
  this.$el.off("click");
};



//
//  Actions
//
FileMetadata.prototype.commit_click_handler = function() {
  this.copy_attributes_to_xfile();
  this.hide();
};


FileMetadata.prototype.cancel_click_handler = function() {
  this.hide();
};



//
//  Attributes
//
FileMetadata.prototype.copy_attributes_to_xfile = function() {
  var $xattr = this.$xfile.find(".attributes");
  var new_attributes_container;

  if ($xattr.length === 0) {
    new_attributes_container = document.createElement("div");
    new_attributes_container.className = "attributes";
    new_attributes_container.innerHTML = this.get_form_template();

    this.$xfile.prepend(new_attributes_container);
    $xattr = $(new_attributes_container);

    this.fileuploader.remove_hidden_fields_from_checkboxes($xattr);
  }

  this.$el.find(".fields [name]").each(function() {
    var $field = $(this),
        tag_name = this.tagName.toLowerCase(),
        sel_attr_name = '[name="' + $field.attr("name") + '"]',
        $xattr_field = $xattr.find(sel_attr_name);

    // input
    if (tag_name == "input") {
      if ($field.attr("type") == "checkbox") {
        $xattr_field = $xattr_field.filter("[type=\"checkbox\"]");

        if ($field.is(":checked")) {
          $xattr_field.attr("checked", "checked");
          $xattr_field.val($field.val());
        } else {
          $xattr_field.removeAttr("checked");
        }
      } else {
        $xattr_field.val( $field.val() );
        $xattr_field.attr("value", $field.val() );
      }

    // textarea
    } else if (tag_name == "textarea") {
      $xattr_field.val( $field.val() );
      $xattr_field.html( $field.val() );

    // select
    } else if (tag_name == "select") {
      var $selected_thru_attr =  $field.children("[selected]"),
          $selected_alt = $field.children(":selected");

      if ($selected_thru_attr.get(0) !== $selected_alt.get(0)) {
        $selected_thru_attr.removeAttr("selected");
        $selected_alt.attr("selected", "selected");
      }

      $xattr_field.html( $field.html() );

    }
  });
};



//
//  Other
//
FileMetadata.prototype.hide = function() {
  this.unbind_events();
  Overlay.get_instance().hide();
};



//
//  -> EXPORT
//
module.exports = FileMetadata;
