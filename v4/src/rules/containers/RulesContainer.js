import React from 'react';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom'

import RulesPage from '../components/RulesPage';

export class RulesContainer extends React.Component {
    render() {
        return (
            <RulesPage>
                { this.props.children }
            </RulesPage>
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
)(RulesContainer));
