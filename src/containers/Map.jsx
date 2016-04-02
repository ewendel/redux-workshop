import React, { PropTypes } from 'react';
import { connect } from 'react-redux';

import { selectTweet } from '../actions';

import TweetMap from '../components/TweetMap';
import CountryList from '../components/CountryList';
import CurrentTweet from '../components/CurrentTweet';
import InfluentialTweets from '../components/InfluentialTweets';

class Map extends React.Component {
  constructor(props) {
    super(props);

    this.showTweet = this.showTweet.bind(this);
  }

  showTweet(id) {
    const tweet = this.props.tweets.find(t => t.id === id);
    this.props.dispatch(selectTweet(tweet));
  }

  render() {
    const {
      currentTweet,
      tweets,
      countries,
      filters
    } = this.props;
    const tweet = currentTweet !== null ?
      <CurrentTweet tweet={ currentTweet } /> :
      null;

    return (
      <div>
        <TweetMap
          tweets={ tweets }
          currentTweet={ currentTweet }
          showTweet={ this.showTweet }
          filters={ filters }
        />
        <InfluentialTweets tweets={ tweets } />
        <CountryList countries={ countries } />
        { tweet }
      </div>
    );
  }
}

Map.propTypes = {
  tweets: PropTypes.array,
  tweetCount: PropTypes.number,
  currentTweet: PropTypes.object,
  countries: PropTypes.object,
  filters: PropTypes.array,
  dispatch: PropTypes.func.isRequired
};

const mapStateToProps = state => ({
  tweets: state.tweets,
  currentTweet: state.view.currentTweet,
  countries: state.countries,
  filters: state.filters
});

export default connect(mapStateToProps)(Map);
