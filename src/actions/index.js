import request from 'superagent';

export const TWEET_RECEIVED = 'TWEET_RECEIVED';
export const TWEET_SELECTED = 'TWEET_SELECTED';
export const TWEET_SAVED = 'TWEET_SAVED';
export const SAVED_TWEETS_FETCH = 'SAVED_TWEETS_FETCH';
export const FILTER_ADDED = 'FILTER_ADDED';
export const FILTER_DELETED = 'FILTER_DELETED';
export const FILTER_ACTIVE_CHANGED = 'FILTER_ACTIVE_CHANGED';

export function newTweet(tweet) {
  return {
    type: TWEET_RECEIVED,
    tweet
  };
}

export function selectTweet(tweet) {
  return {
    type: TWEET_SELECTED,
    tweet
  };
}

export function saveTweet(tweet) {
  return dispatch => {
    request
      .post('/api/savedTweets', tweet)
      .end((err, res) => {
        if (err) {
          console.error(err);
        } else {
          dispatch({
            type: TWEET_SAVED,
            tweet
          });
        }
      });
  };
}

export function fetchSavedTweets() {
  return dispatch => {
    request
      .get('/api/saveTweets')
      .end((err, res) => {
        if (err) {
          console.error(err);
        } else {
          dispatch({
            type: SAVED_TWEETS_FETCH,
            tweets: res.body
          });
        }
      });
  };
}

export function addFilter(filter) {
  return {
    type: FILTER_ADDED,
    filter
  };
}

export function deleteFilter(filter) {
  return {
    type: FILTER_DELETED,
    filter
  };
}

export function setFilterActive(filter, active) {
  return {
    type: FILTER_ACTIVE_CHANGED,
    filter,
    active
  };
}
