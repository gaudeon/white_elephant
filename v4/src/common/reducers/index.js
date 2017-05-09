import { combineReducers } from 'redux';

const dummy = (state = 'OK', action) => {
    return state;
};

const rootReducer = combineReducers({
    dummy
});

export default rootReducer;
