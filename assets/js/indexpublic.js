import "phoenix_html";
import { Socket } from "phoenix";

const Elm = require("../src/elm/MainPublic");
var main = document.getElementById("main");
if (!main) {
    console.log("could not find div");
} else {
    console.log("yayy!");
}
var app = Elm.MainPublic.embed(main);

var gmap;

app.ports.infoForOutside.subscribe(function(elmData) {
    var tag = elmData.tag;
    switch (tag) {
        case "initMap":
            initMap();
            break;
        default:
            console.log("Unrecognized type");
            break;
    }
});

function initMap() {
    if (!google) {
        console.log("google not found");
        return;
    }
    console.log("in initMap");
    var defaultIcon = function(icon) {
        icon.size = icon.size || new google.maps.Size(44, 80);
        icon.scaledSize = icon.scaledSize || new google.maps.Size(22, 40);
        icon.anchor = new google.maps.Point(11, 40);
        return icon;
    };

    var redIcon = defaultIcon({
        url: "images/pin-red.png",
    });

    var gmapsId = "gmaps";
    var mapDiv = document.getElementById(gmapsId);
    if (mapDiv) {
        // Map
        var myLatlng = new google.maps.LatLng({ lat: 45.4, lng: 4.8 });
        var mapOptions = {
            zoom: 3,
            center: myLatlng,
            minZoom: 1,
            maxZoom: 17,
            streetViewControl: false,
            disableDefaultUI: true,
            clickableIcons: false,
            zoomControl: true,
        };
        gmap = new google.maps.Map(mapDiv, mapOptions);
    } else {
        console.log("Cannot find map dom: ", "#" + gmapsId);
    }
}
