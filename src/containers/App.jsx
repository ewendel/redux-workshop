import React, {PropTypes} from 'react';
import {connect} from 'react-redux';

import If from './If';
import IfChild from './IfChild';
import AppHeader from '../components/AppHeader.jsx';
import Feed from './Feed';
import Map from './Map';

function App({route, tweetCount}) {
  return (
    <div>
      <AppHeader tweetCount={ tweetCount } />
      <If condition={ route === '/feed' }>
        <IfChild>
          <Feed />
        </IfChild>
        <IfChild>
          <Map />
        </IfChild>
      </If>
    </div>
  );
}

App.propTypes = {
  tweetCount: PropTypes.number.isRequired,
};

const mapStateToProps = state => ({
  tweetCount: state.tweets.length,
  route: state.route
});

export default connect(mapStateToProps)(App);
