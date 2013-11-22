//
//  Debounce (from underscore.js)
//
exports.debounce = function(func, wait, immediate) {
  var timeout, args, context, timestamp, result;

  // get time helper
  var getTime = (Date.now || function() {
    return new Date().getTime();
  });

  // debounce
  return function() {
    context = this;
    args = arguments;
    timestamp = getTime();
    var later = function() {
      var last = getTime() - timestamp;
      if (last < wait) {
        timeout = setTimeout(later, wait - last);
      } else {
        timeout = null;
        if (!immediate) {
          result = func.apply(context, args);
          context = args = null;
        }
      }
    };
    var callNow = immediate && !timeout;
    if (!timeout) {
      timeout = setTimeout(later, wait);
    }
    if (callNow) {
      result = func.apply(context, args);
      context = args = null;
    }

    return result;
  };
};
