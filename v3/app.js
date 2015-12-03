'use strict';

var express = require('express');

// Constants
var PORT = 8080;

// App
var app = module.exports.app = exports.app = express();

app.use(express.static(__dirname + '/app'));

app.use(express.static(__dirname + '/bower_components'));

app.use(require('connect-livereload')());

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/app/index.html');
});

app.get('/components/:subdir/:file', function(req, res) {
    if (! req.params.file.match(/(?:\.html|\.js)$/)) {
        res.status(404).end();
    }
    else {
        res.sendFile(__dirname + '/bower_components/' + req.params.subdir + '/' + req.params.file);
    }
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
