import React from 'react';
import { connect } from 'react-redux';

import PlayPage from '../components/PlayPage';

export class PlayContainer extends React.Component {
    render() {
        return (
            <PlayPage>
                { this.props.children }
            </PlayPage>
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
)(PlayContainer);
