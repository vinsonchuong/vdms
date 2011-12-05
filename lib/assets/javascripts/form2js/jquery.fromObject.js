(function($) {

  /**
   * jQuery wrapper for js2form()
   */
  $.fn.fromObject = function(options) {
    var settings = {
      data: {},
      delimiter: ".",
      nodeCallback: null,
      useIdIfEmptyName: false
    };

    if (options)
      $.extend(settings, options);

    this.each(function() {
      js2form(
        this,
        settings.data,
        settings.delimiter,
        settings.skipEmpty,
        settings.nodeCallback,
        settings.useIdIfEmptyName
      );

    });
  }
})(jQuery);
