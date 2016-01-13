'use strict';
var express = require('express');
var app = express();

console.log('starting');

app.get('/', function (req, res) {
  console.log('got a request');
  res.send('Hello World');
});

var port = process.env.PORT || 8888;
console.log('Listening on port: ' + port);
app.listen(port);
