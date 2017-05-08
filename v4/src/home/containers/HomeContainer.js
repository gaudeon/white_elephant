import React from 'react';
import { connect } from 'react-redux';

import Home from '../components/Home';


export class HomeContainer extends React.Component {
    render() {
        return (
            <Home/>
        );
    }
}

const mapStateToProps = (state) => {
    return {

    }
}

const mapDispatchToProps = (dispatch) => {
    return {

    }
}

export default connect(
    mapStateToProps,
    mapDispatchToProps
)(HomeContainer);
