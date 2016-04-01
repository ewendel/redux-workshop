import React from 'react';
import {connect} from 'react-redux';

import AppHeader from '../components/AppHeader.jsx';

export default function App({children, tweetCount}) {
  return (
      <div>
          <AppHeader tweetCount={ tweetCount } />
          {children}
      </div>
  );
}

const mapStateToProps = state => ({
    tweetCount: state.view.tweetCount,
});

export default connect(mapStateToProps)(App);
