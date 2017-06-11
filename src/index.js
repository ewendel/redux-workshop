import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';

import configureStore from './configureStore';
import { newTweet } from './actions';
import {findFilterMatch} from './util/filters.js';

import App from './containers/App';

const MAX_TWEETS = 5000;

const store = configureStore();

const ws = new WebSocket('ws://twitterws.herokuapp.com');

ws.onmessage = ms => {
  const tweet = JSON.parse(ms.data);
  if (store.getState().tweets.length < MAX_TWEETS) {
    store.dispatch(newTweet(tweet));
  }
};

render(
  <Provider store={ store }>
    <div>
      <App />
    </div>
  </Provider>,
  document.querySelector('#app')
);
