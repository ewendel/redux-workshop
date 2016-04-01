import React from 'react';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';
import createBrowserHistory from 'history/lib/createBrowserHistory';

import Dashboard from './containers/Dashboard.jsx';
import Settings from './containers/Settings.jsx';
import App from './containers/App.jsx';


export default () => (
    <Router history={browserHistory}>
        <Route path="/" component={ App }>
            <IndexRoute component={ Dashboard }/>
            <Route path="/settings" component={ Settings }/>
        </Route>
    </Router>
);
