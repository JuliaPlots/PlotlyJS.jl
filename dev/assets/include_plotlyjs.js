if (typeof require !== "undefined") {
  console.log("Trying to load plotly.js via requirejs");
  require.undef("plotly");
  requirejs.config({
    paths: {
      plotly: ["https://cdn.plot.ly/plotly-2.3.0.min"],
    },
  });
  require(["plotly"], function (Plotly) {
    window._Plotly = Plotly;
  });
}
