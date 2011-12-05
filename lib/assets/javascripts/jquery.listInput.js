(function($) {
  var
    default_settings = {
      addButton: '<button type="button"></button>',
      listItem: '<li>' +
          '<span class="ui-icon ui-icon-arrowthick-2-n-s"></span>' +
          '<input type="text" required="required">' +
          '<button type="button"></button>' +
          '</li>',
      inputName: function(pos) {return pos},
      items: ['']
    },
    methods = {
      init: function(options) {
        var
          $list = this,
          settings = $.extend({}, default_settings, options)
        ;
        settings.addButton = $(settings.addButton);
        settings.listItem = $(settings.listItem);
        $list.data('settings', settings);

      $list.sortable({
        handle: 'span',
        stop: function() {
          $list.children().each(function(pos, item) {
            $($(item).children('input')).attr('name', settings.inputName(pos))
          })
        }
      }).disableSelection();

      for (var itemNo = -1; ++itemNo < settings.items.length;)
        add_item($list, settings, settings.items[itemNo]);

      settings.addButton
          .button({icons:{primary:'ui-icon-circle-plus'}})
          .click(function() {
            add_item($list, settings).children('input').focus()
          });
        $list.after(settings.addButton);
      },
      setItems: function(items) {
        var
          $list = this,
          settings = $list.data('settings')
        ;
        $list.empty();
        for (var itemNo = -1; ++itemNo < items.length;)
          add_item($list, settings, items[itemNo]);
      }
    }
  ;

  function add_item($list, settings, value) {
    var
      $item = settings.listItem.clone(),
      $input = $item.children('input')
    ;
    $input.attr('name', settings.inputName($list.children().length));
    $input.val(value || '');
    $item
        .children('button')
        .button({icons:{primary:'ui-icon-circle-close'}})
        .click(function() {$item.remove()});
    $list.append($item);
    return $item;
  }

  $.fn.listInput = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' + method + ' does not exist.');
    }
  }
})(jQuery);
