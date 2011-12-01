(function($) {
  $.fn.listInput = function(options) {
    var settings = $.extend({
      addButton: '<button></button>',
      listItem: '<li>' +
                  '<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>' +
                  '<input type="text">' +
                  '<button></button>' +
                '</li>',
      inputName: function(pos) {return pos}
    }, options);

    settings.addButton = $(settings.addButton);
    settings.listItem = $(settings.listItem);

    return this.each(function() {
      var $list = $(this);

      $list.sortable({
        handle: 'span',
        stop: function() {
          $list.children().each(function(index, item) {
            $($(item).children('input')).attr('name', index)
          })
        }
      }).disableSelection();

      settings.addButton
        .button({icons:{primary:'ui-icon-circle-plus'}})
        .click(function() {
        var
          $item = settings.listItem.clone(),
          $input = $item.children('input')
        ;
        $input.attr('name', settings.inputName($list.length));
        $item
          .children('button')
          .button({icons:{primary:'ui-icon-circle-close'}})
          .click(function() {$item.remove()});
        $list.append($item);
        $input.focus();
      });
      $list.after(settings.addButton);
    });
  };
})(jQuery);
