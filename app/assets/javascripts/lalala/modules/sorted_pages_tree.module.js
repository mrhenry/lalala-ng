
var subtrees = null;

exports.init = function(){
  $('table#index_tree_table_pages tbody > tr')
    .not(':has(td.subtree)')
    .addClass('enabled');

  $('table#index_tree_table_pages tbody')
    .sortable({
      // axis:   "y",
      items:  "> tr.enabled",
      helper: fix_helper,
      update: on_update,
      start:  on_start,
      stop:   on_stop
    })
    .disableSelection();
};

function on_start(e, ui) {
  subtrees = ui.item.siblings(':has(td.subtree)');

  subtrees.each(function(){
    var _this = $(this), id;
    if (_this.prev()[0] == ui.placeholder[0]) {
      id = ui.helper.attr("id");
    } else {
      id = _this.prev().attr("id");
    }
    _this.data("prev-id", id);
  });

  subtrees.detach();
}

function on_stop(e, ui) {
  if (subtrees) {
    var p = $(e.target);

    subtrees.each(function(){
      var _this = $(this);
      var prev  = $("#"+_this.data("prev-id"),p);
      prev.first().after(_this);
    });

    subtrees = null;
  }
}

function fix_helper(e, ui) {
  ui.children().each(function() {
    $(this).width($(this).width());
  });
  return ui;
}

function on_update(e, ui) {
  var ids = [];

  $(e.target).children("tr.enabled").each(function(){
    ids.push($(this).data("id"));
  });

  $.ajax({
    type: "PUT",
    url:  window.location.href + "/order",
    data: {"ordered_ids":ids}
  });
}
