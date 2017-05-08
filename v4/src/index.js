import React from 'react';
import ReactDOM from 'react-dom';
import { Router, Route, hashHistory, IndexRoute, Link } from 'react-router';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import ReduxPromise from 'redux-promise';
import App from './App';

// sass
import './common/assets/styles/main.scss';

import HomeContainer from './home/containers/HomeContainer';

ReactDOM.render(
  <Router history={hashHistory}>
    <Route path="/" component={HomeContainer}>
    </Route>
  </Router>,
  document.getElementById('root')
);
