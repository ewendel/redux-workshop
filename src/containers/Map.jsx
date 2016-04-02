import React, { PropTypes } from 'react';
import { connect } from 'react-redux';

import { selectTweet, setFilterActive } from '../actions';

import TweetMap from '../components/TweetMap';
import CountryList from '../components/CountryList';
import CurrentTweet from '../components/CurrentTweet';
import InfluentialTweets from '../components/InfluentialTweets';
import FilterList from '../components/FilterList';

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
      filters,
      dispatch
    } = this.props;
    const tweet = currentTweet !== null ?
      <CurrentTweet tweet={ currentTweet } /> :
      null;

    const activeFilters = filters.filter(f => f.isActive);

    return (
      <div>
        <TweetMap
          tweets={ tweets }
          currentTweet={ currentTweet }
          showTweet={ this.showTweet }
          filters={ activeFilters }
        />
        <InfluentialTweets tweets={ tweets } />
        <CountryList countries={ countries } />
        <FilterList
          filters={ filters }
          onFilterActiveChange={ (f, active) => dispatch(setFilterActive(f, active)) }
        />
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
  filters: PropTypes.array.isRequired,
  dispatch: PropTypes.func.isRequired
};

const mapStateToProps = state => ({
  tweets: state.tweets,
  currentTweet: state.view.currentTweet,
  countries: state.countries,
  filters: state.filters.map(f => ({
    ...f,
    isActive: state.view.activeFilterIdsMap[f.id]
  }))
});

export default connect(mapStateToProps)(Map);
