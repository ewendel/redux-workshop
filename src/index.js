/* global gmap google */

const Elm = require('./Main.elm');

const elmDiv = document.getElementById('app');
const mapDiv = document.getElementById('map');

const app = Elm.Main.embed(elmDiv);

app.ports.showMap.subscribe(() => {
  mapDiv.style.display = 'block';
});

app.ports.hideMap.subscribe(() => {
  mapDiv.style.display = 'none';
});

const handleMarkerClick = id => {
  app.ports.markerClicked.send(id);
};

const markers = new Map();
app.ports.changeMarkerIcon.subscribe(([id, iconUrl]) => {
  const marker = markers.get(id);
  if (marker) {
    marker.setIcon(iconUrl);
  }
});

app.ports.showMarkers.subscribe(newMarkers => {
  newMarkers.forEach(([m, iconUrl]) => {
    if (markers.has(m.id)) {
      return;
    }
    const marker = new google.maps.Marker({
      icon: iconUrl,
      position: m.pos,
      map: gmap
    });

    marker.addListener('click', () => handleMarkerClick(m.id));

    markers.set(m.id, marker);
  });
  for (const [id, marker] of markers) {
    if (newMarkers.findIndex(([m]) => m.id === id) === -1) {
      marker.setMap(null);
      markers.delete(id);
    }
  }
});
