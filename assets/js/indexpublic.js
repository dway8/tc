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

// app.ports.infoForOutside.subscribe(function(elmData) {
//     var tag = elmData.tag;
//     switch (tag) {
//         case "initSearch":
//             setTimeout(function() {
//                 console.log("in init search");
//                 var containerId = elmData.data;
//                 var container = document.getElementById(containerId);
//                 initSearch(container, function(result) {
//                     var res = { tag: "placeSelected", data: result };
//                     app.ports.infoForElm.send(res);
//                 });
//             }, 300);
//             break;
//         default:
//             console.log("Unrecognized type");
//             break;
//     }
// });
//
// function initSearch(container, callback) {
//     if (typeof google === "undefined") {
//         return;
//     }
//     if (!container) {
//         return;
//     }
//     var options = {};
//
//     options.types = ["address"];
//
//     var searchBox = new google.maps.places.Autocomplete(container, options);
//
//     global.searchBox = searchBox;
//     searchBox.addListener(
//         "place_changed",
//         autocompleteResults(searchBox, callback)
//     );
// }
//
// function autocompleteResults(searchBox, callback) {
//     return function() {
//         var place = searchBox.getPlace();
//
//         var addressFields = {};
//
//         var addressComponents = place.address_components;
//
//         if (!addressComponents) {
//             // user didn't select one of the proposals
//             return;
//         }
//
//         for (var i = 0; i < addressComponents.length; i++) {
//             var type = addressComponents[i]["types"][0];
//             addressFields[type] = addressComponents[i]["long_name"];
//         }
//
//         var street_number = addressFields["street_number"] || "";
//         var route = addressFields["route"] || "";
//         var address = (street_number + " " + route).trim();
//
//         var result = {
//             searchAddress: place.formatted_address,
//             address: address,
//             city: addressFields["locality"],
//             coordinates: {
//                 lat: place.geometry.location.lat(),
//                 lng: place.geometry.location.lng(),
//             },
//         };
//         console.log("result ", result);
//
//         callback(result);
//     };
// }
