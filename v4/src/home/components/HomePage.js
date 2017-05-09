import React from 'react';

export default class HomePage extends React.Component {
    render() {
        return (
            <div>
                <h2>Welcome to the White Elephant Gift Exchange App!</h2>
                { this.props.children }
            </div>
        );
    }
}
