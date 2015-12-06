'use strict';

var express = require('express');
var bodyParser = require('body-parser');

// Constants
var PORT = 8080;
var PLAYERS = [];

// App
var app = module.exports.app = exports.app = express();

app.use(express.static(__dirname + '/app'));

app.use('/bower_components', express.static(__dirname + '/bower_components'));

// form body parsing
app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

app.use(require('connect-livereload')());

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/app/index.html');
});

app.get('/players', function(req, res) {
    res.json(PLAYERS);
});

app.post('/players', function (req, res) {
    PLAYERS.push(req.body);

    res.json({
        player: req.body,
        success: true
    });
});

app.delete('/players', function(req, res) {
    PLAYERS.splice(req.body.index, 1);

    res.json({
        success: true
    });
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
