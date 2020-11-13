(function ($) {
  $(window).on("load", function() {
    $('[data-copy]').each(function() {
      const element = $(this);
      element.on("click", function() {
        var $temp = $("<input>");
        $("body").append($temp);
        $temp.val(element.data("url")).select();
        document.execCommand("copy");
        $temp.remove();
      })
    })
  });
})(jQuery);
