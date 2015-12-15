'use strict';

var express = require('express');
var bodyParser = require('body-parser');

// Constants
var PORT = 8080;
var PLAYERS = [];
var GAME = {};

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
    var p = new_player( req.body.player, req.body.present );

    PLAYERS.push( p );

    res.json({
        "player": p,
        "success": true
    });
});

app.delete('/players', function(req, res) {
    PLAYERS.splice(req.body.index, 1);

    res.json({
        success: true
    });
});

app.get('/play', function(req, res) {
    randomize(req.query.force ? true : false);

    res.json(GAME);
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);

// ----- White Elephant Functions -----
function randomize(force) {
    if (typeof(GAME.players) !== 'undefined' && GAME.players.length == PLAYERS.length && ! force) {
        return GAME;
    }

    GAME = {}; // reset calculated GAME data

    var running = 1;
    while (running) {
        try {
            var rp = randomize_presents();
        } catch(e) {
            continue;
        }

        running = 0;
        GAME.players = rp;
    }


    GAME.order_of_play = randomize_player_order();

    GAME.order_of_play_by_name = [];
    for (var oop = 0; oop < GAME.players.length; oop++) {
        GAME.order_of_play_by_name.push(GAME.players[ GAME.order_of_play[oop] ].player); // List order of play by player name
    }

    // Game On!
}

function randomize_presents() {
    var rand_presents = [];
    var used = {};

    for (var i = 0; i < PLAYERS.length; i++) { // loop through each player
        rand_presents[i] = new_player();

        rand_presents[i].player = PLAYERS[i].player;

        var present_from_player = -1;
        for (var r = 0; r <= PLAYERS.length * 100; r++) { // limit the loop here, no need for an infinite one
            var pnp = rand_range(0, PLAYERS.length - 1);

            // if the present from player we found is not from the same player that we are one and it's unassigned, give it to the current player
            if (i != pnp && (typeof(used[pnp]) === 'undefined' || used[pnp] != 1)) {
                used[pnp] = 1;
                present_from_player = pnp;
                break;
            }
        }

        // sometimes presets are given in such a way that one player has no choice but to be assigned their own, we throw if that happens so we can try again in the main randomize function
        if (present_from_player == -1) {
            throw('Failed to find random present for player ' + i + ' this probably means we only could assign the present he brought.');
        }

        // yay random assignment worked! give the present
        rand_presents[i].present = PLAYERS[present_from_player].present;
    }

    return rand_presents;
}

function randomize_player_order() {
    var rand_players = [];
    var used = {};

    for (var i = 0; i < PLAYERS.length; i++) { // loop through each player

        var rand_player_index = -1;
        for (var r = 0; r <= PLAYERS.length * 100; r++) { // limit the loop here, no need for an infinite one
            var rp = rand_range(0, PLAYERS.length - 1);

            // find a player we already haven't randomized
            if (typeof(used[rp]) === 'undefined' || used[rp] != 1) {
                used[rp] = 1;
                rand_player_index = rp;
                break;
            }
        }

        // just make sure we found one
        if (rand_player_index == -1) {
            throw('Failed to find random order of play for player ' + i + '. This should not happen so something wierd is going on...');
        }

        // yay random assignment worked! give the present
        rand_players[i] = rand_player_index;
    }

    return rand_players;
}

function rand_range(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function new_player(player, present) {
    player = player || '';
    present = present || 0;

    return {
        "player": player,
        "present": present
    };
}

