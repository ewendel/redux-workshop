import React from 'react';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';

import Map from './containers/Map.jsx';
import Feed from './containers/Feed.jsx';
import App from './containers/App.jsx';


export default () => (
    <Router history={browserHistory}>
        <Route path="/" component={ App }>
            <IndexRoute component={ Map }/>
            <Route path="/feed" component={ Feed }/>
        </Route>
    </Router>
);
