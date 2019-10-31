'use strict';
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var util = require('util');
var crypto = require('crypto');

console.log('starting');

var jsonParser = bodyParser.json();
var urlEncodedParser = bodyParser.urlencoded({extended: false});

app.get('/', function(req, res) {
  console.log('got a request');
  var response ='<html><h2>Hello, frogs!</h2></html>'
  res.send(response);
});

app.post('/', jsonParser, postJSONHandler);
app.post('/json', jsonParser, postJSONHandler);
app.post('/url', urlEncodedParser, postUrlHandler);
app.post('/secret', jsonParser, postSecretHandler);

var port = process.env.PORT || 8888;
console.log('Listening on port: ' + port);
app.listen(port);

function postJSONHandler(req, res) {
  console.log('================ BEGIN request body ========');
  console.log(util.inspect(req.body));
  console.log('================ END request body ==========');
  console.log('================ BEGIN request headers =====');
  console.log(util.inspect(req.headers));
  console.log('================ END request headers =======');
  console.log('POST processing complete for path: ' + req.url);
  res.sendStatus(200);
}

function postUrlHandler(req, res) {
  console.log('================ BEGIN request body ========');
  console.log(util.inspect(req.body));
  console.log('================ END request body ==========');
  console.log('================ BEGIN request headers =====');
  console.log(util.inspect(req.headers));
  console.log('================ END request headers =======');
  res.sendStatus(200);
}

function postSecretHandler(req, res) {

  console.log('================ BEGIN request body ========');
  console.log(util.inspect(req.body));
  console.log('================ END request body ==========');
  console.log('================ BEGIN request headers =====');
  console.log(util.inspect(req.headers));
  console.log('================ END request headers =======');

  var secret = 'foobar';
  var body = JSON.stringify(req.body);
  var hmac = crypto.createHmac('sha256', secret).update(body).digest('hex');
  if (('sha256=' + hmac) !== req.headers['x-hub-signature'])
    console.log('!!!!!!!!!! uh oh, unmatched signature. try again!!!!!!!!!!!')
  else
    console.log('---------- wow, the signatures match! you know my secret!-----------');

  console.log('POST processing complete for path: ' + req.url);
  res.sendStatus(200);
}
