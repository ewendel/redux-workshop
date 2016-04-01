import React from 'react';
import { Link } from 'react-router'

import Timer from './Timer';

export default function AppHeader({ tweetCount }) {
  return (
    <div className="app-header">
        <div className="menu-bar">
            <Link to="/" className="img img-icon img-icon-dashboard"/>
            <Link to="/feed" className="img img-icon img-icon-settings"/>
        </div>
      <h1 className="heading">Twitterizer</h1>
      <div>
        <span className="tweet-stats-desc">seconds running</span>
        <strong><Timer /></strong>
      </div>
      <div>
        <span className="tweet-stats-desc">tweets captured</span>
        <strong>{ tweetCount }</strong>
      </div>
    </div>
  );
}
