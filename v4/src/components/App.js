import React, { Component } from 'react';
import { Nav, NavItem } from 'react-bootstrap';
import '../assets/styles/components/App.scss';

class App extends Component {
    render() {
        return (
        <main>
                        <h1>White Elephant Exchange</h1>
                        <Nav bsStyle="pills">
                            <NavItem>Rules</NavItem>
                            <NavItem>Players</NavItem>
                            <NavItem>Play!</NavItem>
                        </Nav>
        </main>
        );
    }
}

export default App;
