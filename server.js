'use strict';
var express = require('express');
var app = express();
// blah1
console.log('starting');

app.get('/', function(req, res) {
  console.log('got a request!');
  var response ='<html><h2>Hello, frogs!</h2></html>'
  res.send(response);
});

var port = process.env.PORT || 8888;
console.log('Listening on port: ' + port);
app.listen(port);
