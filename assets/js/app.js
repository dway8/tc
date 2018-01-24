// import "phoenix_html";
// import { Socket } from "phoenix";

const Elm = require("../src/elm/Main");
var main = document.getElementById("main");
if (!main) {
    console.log("could not fiind div");
} else {
    console.log("yayy!");
}
Elm.Main.embed(main);
