// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some#Polyfill
// Production steps of ECMA-262, Edition 5, 15.4.4.17
// Reference: http://es5.github.io/#x15.4.4.17
if (!Array.prototype.some) {
  Array.prototype.some = function(fun/*, thisArg*/) {
    'use strict';

    if (this == null) {
      throw new TypeError('Array.prototype.some called on null or undefined');
    }

    if (typeof fun !== 'function') {
      throw new TypeError();
    }

    var t = Object(this);
    var len = t.length >>> 0;

    var thisArg = arguments.length >= 2 ? arguments[1] : void 0;
    for (var i = 0; i < len; i++) {
      if (i in t && fun.call(thisArg, t[i], i, t)) {
        return true;
      }
    }

    return false;
  };
}

// https://gist.github.com/addyosmani/d5648c89420eb333904c
if (![].fill)  {
  Array.prototype.fill = function(value) {

    var O = Object(this);
    var len = parseInt(O.length, 10);
    var start = arguments[1];
    var relativeStart = parseInt(start, 10) || 0;
    var k = relativeStart < 0
            ? Math.max(len + relativeStart, 0) 
            : Math.min(relativeStart, len);
    var end = arguments[2];
    var relativeEnd = end === undefined
                      ? len 
                      : (parseInt(end)  || 0) ;
    var final = relativeEnd < 0
                ? Math.max(len + relativeEnd, 0)
                : Math.min(relativeEnd, len);

    for (; k < final; k++) {
        O[k] = value;
    }

    return O;
  };
}
