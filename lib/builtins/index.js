var extend;

extend = require('extend');

extend(exports, require('./accordion'));

exports.triangle = require('./triangle');

exports.dialog = require('./dialog');

extend(exports, require('./combo'));

extend(exports, require('./autoWidthEdit'));
