import React from 'react';
import ReactDOM from 'react-dom';
import { HashRouter as Router, Route } from 'react-router-dom';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import ReduxPromise from 'redux-promise';

// sass
import './common/assets/styles/main.scss';

// redux reducers and store using ReduxPromise as middleware
import reducers from './common/reducers';
const createStoreWithMiddleware = applyMiddleware(ReduxPromise)(createStore);

// top level containers
import PageContainer from './common/containers/PageContainer';

ReactDOM.render(
    <Provider store={createStoreWithMiddleware(reducers)}>
        <Router>
            <Route path="/" component={PageContainer} />
        </Router>
    </Provider>,
    document.getElementById('root')
);
