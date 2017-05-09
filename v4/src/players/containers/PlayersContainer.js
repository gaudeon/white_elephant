import React from 'react';
import { connect } from 'react-redux';

import PlayersPage from '../components/PlayersPage';

export class PlayersContainer extends React.Component {
    render() {
        return (
            <PlayersPage>
                { this.props.children }
            </PlayersPage>
        );
    }
}

const mapStateToProps = (state) => {
    return {
    };
}

const mapDispatchToProps = (dispatch) => {
    return {
    };
}

export default connect(
    mapStateToProps,
    mapDispatchToProps
)(PlayersContainer);
