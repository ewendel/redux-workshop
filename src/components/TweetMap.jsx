import React, { PropTypes } from 'react';
import { GoogleMap, Marker, GoogleMapLoader } from 'react-google-maps';
import { findFilterMatch } from '../util/filters';

function TweetMap({
  tweets,
  showTweet,
  currentTweet,
  filters
}) {
  const markers = tweets.map(t => {
    const callback = () => {
      showTweet(t.id);
    };

    const filterMatch = findFilterMatch(t, filters);
    const color = filterMatch ? filterMatch.color : null;

    let icon = 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';
    if (t === currentTweet) {
      icon = 'http://maps.google.com/mapfiles/ms/icons/green-dot.png';
    } else if (color) {
      icon = `http://maps.google.com/mapfiles/ms/icons/${color}-dot.png`;
    }

    return (
      <Marker
        key={ t.id }
        onClick={ callback }
        icon={ icon }
        position={{ lat: t.geo.coordinates[0], lng: t.geo.coordinates[1] }}
      />
    );
  });

  return (
    <div className="tweet-map">
      <GoogleMapLoader
        googleMapElement={
          <GoogleMap
            defaultZoom={3}
            defaultCenter={{ lat: 30.675226, lng: -35.051272 }}
          >
            { markers }
          </GoogleMap>
        }
      />
    </div>
  );
}

TweetMap.propTypes = {
  tweets: PropTypes.array.isRequired,
  showTweet: PropTypes.func.isRequired,
  currentTweet: PropTypes.object,
  filters: PropTypes.array
};

export default TweetMap;
