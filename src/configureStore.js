import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import rootReducer from './reducers';
import { composeWithDevTools } from 'redux-devtools-extension';

const composeEnhancers = composeWithDevTools({
  actionsBlacklist: ['TWEET_RECEIVED']
});

export default function (initialState) {
  return createStore(rootReducer, initialState, composeEnhancers(
    applyMiddleware(thunk)
  ));
}
