var overlay, fn_template;


fn_template = function() {
  return [
    '<div class="overlay-outer-wrapper">',
      '<div class="overlay-inner-wrapper"></div>',
    '</div>'
  ].join('');
};



function create_new_instance() {
  overlay = new Overlay(false, {
    content_class_name: "overlay-inner-wrapper",
    template_function: fn_template
  });
}



//
//  -> EXPORT
//
module.exports = {

  get_instance: function() {
    if (!overlay) create_new_instance();
    return overlay;
  }

};
