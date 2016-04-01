import React from 'react';

import Dashboard from './Dashboard';
import {Link} from 'react-router';

export default function App({children}) {
  return (
      <div>
        <h1><Link to="/">Dashboard</Link></h1>
        <h1><Link to="/settings">Settings</Link></h1>
            {children}
      </div>
  );
}
