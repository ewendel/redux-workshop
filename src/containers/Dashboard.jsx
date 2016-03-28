import React, { PropTypes } from 'react';
import { connect } from 'react-redux';

import { selectTweet } from '../actions';

import TweetMap from '../components/TweetMap';
import AppHeader from '../components/AppHeader';
import CountryList from '../components/CountryList';
import CurrentTweet from '../components/CurrentTweet';
import InfluentialTweets from '../components/InfluentialTweets';

class Dashboard extends React.Component {
  constructor(props) {
    super(props);

    this.showTweet = this.showTweet.bind(this);
  }

  showTweet(id) {
    const tweet = this.props.tweets.find(t => t.id === id);
    this.props.dispatch(selectTweet(tweet));
  }

  render() {
    const { currentTweet, tweets, tweetCount, countries } = this.props;
    const tweet = currentTweet !== null ?
      <CurrentTweet tweet={ currentTweet } /> :
      null;

    return (
      <div>
        <TweetMap
          tweets={ tweets }
          currentTweet={ currentTweet }
          showTweet={ this.showTweet }
        />
        <InfluentialTweets tweets={ tweets } />
        <AppHeader tweetCount={ tweetCount } />
        <CountryList countries={ countries } />
        { tweet }
      </div>
    );
  }
}

Dashboard.propTypes = {
  tweets: PropTypes.array,
  tweetCount: PropTypes.number,
  currentTweet: PropTypes.object,
  countries: PropTypes.object,
  dispatch: PropTypes.func.isRequired
};

const mapStateToProps = state => ({
  tweets: state.tweets,
  tweetCount: state.view.tweetCount,
  currentTweet: state.view.currentTweet,
  countries: state.countries
});

export default connect(mapStateToProps)(Dashboard);
