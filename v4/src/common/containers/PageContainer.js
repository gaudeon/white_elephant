import React from 'react';
import { connect } from 'react-redux';

import PageShell from '../components/PageShell';

export class PageContainer extends React.Component {
    render() {
        return (
            <PageShell>
                { this.props.children }
            </PageShell>
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
)(PageContainer);
