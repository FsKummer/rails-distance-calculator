import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/kummerf/clay1i7ge000o14pkmfen9r86",
      projection: "globe",
      zoom: 1.5,
      center: [-70, 0]
    })
  }
}
