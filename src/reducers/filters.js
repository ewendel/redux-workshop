import {
  FILTER_ADDED,
  FILTER_DELETED
} from '../actions';

const initialState = [];

export default function (state = initialState, action) {
  switch (action.type) {
  case FILTER_ADDED:
    return [
      ...state.all,
      action.filter
    ];
  case FILTER_DELETED:
    return state.filter(f => f.name !== action.filter.id);
  default:
    return state;
  }
}
