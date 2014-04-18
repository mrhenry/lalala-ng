'use strict';


var lalalaStorage = require('lalala/modules/storage'),
    storage_key   = 'collapsible_pages_tree_states';


/**
 * @constructor
 */
function CPT($element) {
  this.$element      = $element;
  this.$tree_parents = this.getTreeParents();
  this.states        = lalalaStorage[storage_key] || [];

  this.addTriggers();
  this.initStates();

  this.$tree_parents.on('click.collapsible_tree', '.collapsable', $.proxy(this.toggleState, this));

  // Best behaviour would be to save on window unload,
  // but the current storage save on unload is wrong,
  // so this will be added after the storage module saves..
  //$(window).unload( $.proxy(this.saveState, this) );
}


/**
 * Get tree items (<tr>'s) with children
 *
 * It adds the target as a data attribute to the tree parent element
 *
 * @return {jQuery Array}
 */
CPT.prototype.getTreeParents = function() {
  return this.$element.find('td.subtree').closest('tr').map(function() {
    var $subtree     = $(this),
        $tree_parent = $(this).closest('tr').prev();

    $tree_parent.data('collapsible_target', $subtree);

    return $tree_parent.get();
  });
};


/**
 * Add trigger column to tree parent rows
 */
CPT.prototype.addTriggers = function() {
  var $trigger = $('<td class="collapse"></td>');

  // Add <td> to every <tr> to keep table structure in balance
  this.$element.find('tr').prepend( $trigger );

  // Activate triggers
  this.$element.find('table.subtree').each(function() {
    var $subtree     = $(this),
        $tree_parent = $subtree.closest('tr').prev();

    $tree_parent.find('.collapse')
      .addClass('collapsable')
      .data('tree_parent', $tree_parent);
  });
};


/**
 * Initialize saved states
 */
CPT.prototype.initStates = function() {
  var _this = this;

  // Close all
  this.$tree_parents.each(function() {
    var $tree_parent = $(this),
        $target      = $tree_parent.data('collapsible_target'),
        $trigger     = $tree_parent.find('.collapse');

    _this.update($target, $trigger, 'close', false);
  });

  // Open saved states
  $.each(this.states, function(idx, value) {
    var $tree_parent = $('#' + value),
        $target      = $tree_parent.data('collapsible_target'),
        $trigger     = $tree_parent.find('.collapse');

    _this.update($target, $trigger, 'open', false);
  });
};


/**
 * Update target state
 *
 * @param  {jQuery object} $target    The element to be closed
 * @param  {jQuery object} $trigger   The trigger element
 * @param  {Boolean}       save_state Default TRUE
 */
CPT.prototype.update = function($target, $trigger, state, save_state) {
  if ( !$target ) {
    console.warn('Collapsible tree: Can not find tree target');
    return;
  }

  save_state = (typeof save_state == 'undefined') ? true : save_state;

  if ( state == 'close' ) {
    $target.hide();
    $trigger.addClass('closed');

  } else if ( state == 'open') {
    $target.show();
    $trigger.removeClass('closed');

  } else {
    console.warn('Collapsible tree: Unknown state');
    return;

  }

  if ( save_state ) {
    this.saveState();
  }
};


/**
 * Toggle collapsible sate
 *
 * @param {jQuery event} event
 */
CPT.prototype.toggleState = function(event) {
  var $trigger = $(event.currentTarget),
      $target  = $trigger.data('tree_parent').data('collapsible_target');

  if ( $target.is(':visible') ) {
    this.update($target, $trigger, 'close');

  } else {
    this.update($target, $trigger, 'open');

  }

  event.preventDefault();
  event.stopPropagation();
};


/**
 * Save tree states by adding the closed ones into an Array
 */
CPT.prototype.saveState = function() {
  var new_states = [];

  this.$tree_parents.each( function() {
    var $tree_parent = $(this),
        $trigger     = $tree_parent.find('.collapse');

    if ( !$trigger.hasClass('closed') ) {
      new_states.push($tree_parent.attr('id'));
    }

  });

  lalalaStorage[storage_key] = this.states = new_states;
};


/**
 * Initialize module
 */
exports.init = function() {
  var $collapsible_page_trees = $('#index_tree_table_pages');

  if ( $collapsible_page_trees.length < 1 ) {
    return;
  }

  $collapsible_page_trees.each( function() {
    var $this = $(this);

    if ( !$this.data('collapsible_pages_tree_instance') ) {
      $this.data( 'collapsible_pages_tree_instance', new CPT($this) );
    }
  });
};
