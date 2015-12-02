'use strict';

var express = require('express');

// Constants
var PORT = 8080;

// App
var app = module.exports.app = exports.app = express();

app.use(express.static(__dirname + '/app'));

app.use(require('connect-livereload')());

app.get('/', function (req, res) {
    res.sendfile('./app/index.html');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
