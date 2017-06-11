import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import rootReducer from './reducers';
import { composeWithDevTools } from 'redux-devtools-extension';

const actionsBlackList = [
  'REMOVE THIS LINE AND UNCOMMENT THE NEXT'
  // 'TWEET_RECEIVED'
];

const composeEnhancers = composeWithDevTools({
    actionsBlackList: actionsBlackList
});

export default function (initialState) {
  return createStore(rootReducer, initialState, composeEnhancers(
    applyMiddleware(thunk)
  ));
}
