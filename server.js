'use strict';
var express = require('express');
var app = express();

console.log('starting');

app.get('/', function(req, res) {
  console.log('got a request');
  var tag = process.env.STEP_ID || 'no tag found';
  var sha = process.env.COMMIT || 'no commit found';
  var response =
    '<html></h2><h3>' +
    'tag: ' +
    tag +
    '</h3><h3>commit: ' +
    sha +
    '</h3></html>';

  res.send(response);
});

app.get('/tag', function(req, res) {
  console.log('got a tag request');
  var tag = process.env.BUILD_NUMBER || 'no build in environment';
  res.send(tag);
});

var port = process.env.PORT || 8888;
console.log('Listening on port: ' + port);
app.listen(port);
