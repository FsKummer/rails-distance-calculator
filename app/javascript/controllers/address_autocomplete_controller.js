import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static values = { apiKey: String }

  static targets = ["pointa", "pointb"]

  connect() {
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,postcode,locality,neighborhood,address"
    })
  }

  calcDist(array) {
    const R = 6371
    const LatLongsArray = array
    const dLat = (LatLongsArray[1].lat - LatLongsArray[0].lat) * (Math.PI/180);
    const dLong = (LatLongsArray[1].long - LatLongsArray[0].long) * (Math.PI/180);
    const a =
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos((LatLongsArray[0].lat) * (Math.PI/180)) * Math.cos((LatLongsArray[1].lat) * (Math.PI/180)) *
    Math.sin(dLong/2) * Math.sin(dLong/2)
    ;
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    const d = R * c; // Distance in km
    console.log(d);
  }

  deg2rad(deg) {
    return deg * (Math.PI/180)
  }

  getLatLong() {
    const LatLongs = []
    fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${this.pointaTarget.value}.json?access_token=pk.eyJ1Ijoia3VtbWVyZiIsImEiOiJjbGEyc2I1ZnQwa2xiM3hvMzE1bnI4bnBvIn0.FlMw1nMbJuYXbPOYgA8ySA`)
      .then(response => response.json())
      .then((data) => {
        LatLongs.push({ long: data.features[0].center[0], lat: data.features[0].center[1] })
        fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${this.pointbTarget.value}.json?access_token=pk.eyJ1Ijoia3VtbWVyZiIsImEiOiJjbGEyc2I1ZnQwa2xiM3hvMzE1bnI4bnBvIn0.FlMw1nMbJuYXbPOYgA8ySA`)
        .then(response => response.json())
        .then((data) => {
          LatLongs.push({ long: data.features[0].center[0], lat: data.features[0].center[1] })
        })
        .then(this.calcDist(LatLongs))
    })
  }

}
