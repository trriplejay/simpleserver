'use strict';
var express = require('express');
var app = express();

console.log('starting');

app.get('/', function (req, res) {
  console.log('got a request');
  var out = 'FOO=' + process.env.BAR
  res.send(out);
});

var port = process.env.PORT || 8888;
console.log('Listening on port: ' + port);
app.listen(port);
