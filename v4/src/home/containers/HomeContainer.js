import React from 'react';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom'

import HomePage from '../components/HomePage';

export class HomeContainer extends React.Component {
    render() {
        return (
            <HomePage>
                { this.props.children }
            </HomePage>
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

export default withRouter(connect(
    mapStateToProps,
    mapDispatchToProps
)(HomeContainer));
