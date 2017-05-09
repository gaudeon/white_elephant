import React from 'react';
import { IndexRoute, Link, Route } from 'react-router-dom';

import HomeContainer from '../../home/containers/HomeContainer';
import RulesContainer from '../../rules/containers/RulesContainer';
import PlayContainer from '../../play/containers/PlayContainer';
import PlayersContainer from '../../players/containers/PlayersContainer';

export default class PageShell extends React.Component {
    render() {
        return (
            <main>
                <div>
                    <Link to="/">Home</Link>
                    <Link to="/rules">Rules</Link>
                    <Link to="/players">Players</Link>
                    <Link to="/play">Play</Link>
                </div>
                { this.props.children }
                <IndexRoute component={HomeContainer} />
                <Route path="rules" component={RulesContainer} />
                <Route path="play" component={PlayContainer} />
                <Route path="players" component={PlayersContainer} />
            </main>
        );
    }
}
