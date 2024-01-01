import L from "leaflet";
import "leaflet-control-geocoder";
import "leaflet.markercluster";
import "../../vendor/L.VisualClick";

const template = document.createElement("template");
template.innerHTML = `
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"
    integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ=="
    crossorigin=""/>
    <link
      rel="stylesheet"
      href="/css/MarkerCluster.css"
    />
    <link
      rel="stylesheet"
      href="/css/L.VisualClick.css"
    />
    <link
      rel="stylesheet"
      href="/css/MarkerCluster.Default.css"
    />
    <link rel="stylesheet" href="https://unpkg.com/leaflet-control-geocoder@2.4.0/dist/Control.Geocoder.css" />
    <div style="height: 100%; width: 100%; z-index: 0;">
        <slot />
    </div>
`;

class LeafletMap extends HTMLElement {
  constructor() {
    super();

    this.attachShadow({ mode: "open" });
    this.shadowRoot.appendChild(template.content.cloneNode(true));

    this.defaultSlot = this.shadowRoot.querySelector("slot");
    this.defaultSlot.addEventListener("slotchange", () =>
      this.slotChange(this)
    );

    this.mapElement = this.shadowRoot.querySelector("div");

    this.map = L.map(this.mapElement).setView(
      [this.getAttribute("lat"), this.getAttribute("lng")],
      this.getAttribute("zoom")
    );

    L.tileLayer("https://{s}.tile.osm.org/{z}/{x}/{y}.png", {
      attribution:
        '&copy; <a href="https://osm.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(this.map);

    // https://github.com/perliedman/leaflet-control-geocoder
    L.Control.geocoder({ position: "topleft", defaultMarkGeocode: false })
      .on(
        "markgeocode",
        function (e) {
          var bbox = e.geocode.bbox;
          var poly = L.polygon(
            [
              bbox.getSouthEast(),
              bbox.getNorthEast(),
              bbox.getNorthWest(),
              bbox.getSouthWest(),
            ],
            { fillColor: "#75b2db", color: "#4e96cf" }
          ).addTo(this.map);
          this.map.fitBounds(poly.getBounds());
        }.bind(this)
      )
      .addTo(this.map);

    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png?{retina}", {
      retina: "", // to be extended for detected Retina displays with value '@2x'
      // maxZoom and maxNativeZoom are necessary to allow zooming beyong 18.5
      // https://gis.stackexchange.com/a/277848
      maxNativeZoom: 18,
      maxZoom: 20,
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(this.map);
  }

  slotChange() {
    this.markerClusterGroup.clearLayers();
    Array.from(this.defaultSlot.assignedNodes()).forEach((markerEl) => {
      if (markerEl.tagName === "LEAFLET-MARKER") {
        const lat = markerEl.getAttribute("lat");
        const lng = markerEl.getAttribute("lng");

        const leafletMarker = L.marker([lat, lng]);

        leafletMarker.addEventListener("mousedown", (event) => {
          event.originalEvent.stopPropagation();
        });
        leafletMarker.addEventListener("click", (event) => {
          event.originalEvent.preventDefault();
          markerEl.click();
        });

        const iconEl = markerEl.querySelector("leaflet-icon");

        iconEl.addEventListener("attribute-changed", (e) => {
          leafletMarker.setOpacity(0.8).setIcon(
            L.icon({
              iconUrl: e.detail,
              iconSize: [25, 41],
              iconAnchor: [12, 41],
            })
          );
        });

        leafletMarker.setOpacity(0.8).setIcon(
          L.icon({
            iconUrl: iconEl.getAttribute("icon-url"),
            iconSize: [25, 41],
            iconAnchor: [12, 41],
          })
        );

        this.markerClusterGroup.addLayer(leafletMarker);
        markerEl.marker = leafletMarker;
      }
    });
  }

  connectedCallback() {
    this.markerClusterGroup = L.markerClusterGroup({ maxClusterRadius: 40 });
    this.map.addLayer(this.markerClusterGroup);
  }
}

window.customElements.define("leaflet-map", LeafletMap);
