import {
  TWEET_RECEIVED,
  TWEET_SELECTED,
  FILTER_ACTIVE_CHANGED,
  FILTER_DELETED
} from '../actions';

const initialState = {
  tweetCount: 0,
  currentTweet: null,
  activeFilterIdsMap: {}
};

export default function (state = initialState, action) {
  switch (action.type) {
  case TWEET_RECEIVED:
    return {
      ...state,
      tweetCount: state.tweetCount + 1
    };
  case TWEET_SELECTED:
    return {
      ...state,
      currentTweet: action.tweet
    };
  case FILTER_ACTIVE_CHANGED:
    return {
      ...state,
      activeFilterIdsMap: {
        ...state.activeFilterIdsMap,
        [action.filter.id]: action.active
      }
    };
  case FILTER_DELETED:
    return {
      ...state,
      activeFilterIdsMap: {
        ...state.activeFilterIdsMap,
        [action.filter.id]: false
      }
    };
  default:
    return state;
  }
}
