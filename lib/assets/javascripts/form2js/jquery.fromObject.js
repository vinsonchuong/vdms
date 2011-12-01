(function($) {

  /**
   * jQuery wrapper for js2form()
   * Adapted from the wrapper for form2js().
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

    js2form(
      this.get(0),
      settings.data,
      settings.delimiter,
      settings.skipEmpty,
      settings.nodeCallback,
      settings.useIdIfEmptyName
    );
  }
})(jQuery);
