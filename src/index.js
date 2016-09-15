/* global gmap google */

const Elm = require('./Main.elm');
const { partition } = require('lodash');

const elmDiv = document.getElementById('app');
const mapDiv = document.getElementById('map');

const app = Elm.Main.embed(elmDiv);

app.ports.showMap.subscribe(() => {
  mapDiv.style.display = 'block';
});

app.ports.hideMap.subscribe(() => {
  mapDiv.style.display = 'none';
});

let markers = [];
app.ports.showMarkers.subscribe(newMarkers => {
  const [activeMarkers, nonactiveMarkers] =
    partition(markers, m =>
      newMarkers.findIndex(nm => nm.id === m.id) > -1
    );

  nonactiveMarkers.forEach(m => m.marker.setMap(null));

  markers = newMarkers
    .filter(nm =>
      markers.findIndex(m => m.id === nm.id) === -1
    )
    .map(m => ({
      id: m.id,
      marker: new google.maps.Marker({
        position: m.pos,
        map: gmap
      })
    }))
    .concat(activeMarkers);
});
