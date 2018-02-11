var path = require("path");
var webpack = require("webpack");
var merge = require("webpack-merge");
var HtmlWebpackPlugin = require("html-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");

var prod = "production";
var dev = "development";

// determine build env
var TARGET_ENV = process.env.npm_lifecycle_event === "build" ? prod : dev;
var isDev = TARGET_ENV == dev;
var isProd = TARGET_ENV == prod;

var apps = ["all", "admin", "public"];
var allApps = ["public", "admin"];

// var outputPath = path.resolve(__dirname + "/dist");
var outputPath = path.resolve(__dirname, "../priv/static/js");
var outputFilename = "app[name].js";

console.log("WEBPACK GO!");

// common webpack config
var commonConfig = {
    output: {
        path: outputPath,
        filename: outputFilename,
        publicPath: "http://localhost:4000",
    },

    resolve: {
        extensions: [".js", ".elm"],
    },

    module: {
        // noParse: /\.elm$/,
        rules: [
            {
                test: /\.(eot|ttf|woff|woff2|svg)$/,
                use: [{ loader: "file-loader" }],
            },
        ],
    },

    // plugins: [
    //     new HtmlWebpackPlugin({
    //         template: "src/static/index.html",
    //         inject: "body",
    //         filename: "index.html",
    //     }),
    // ],
};

// additional webpack settings for local env (when invoked by 'npm start')
if (isDev === true) {
    console.log("Serving locally...");

    module.exports = function(env) {
        if (!env || !env.appName || apps.indexOf(env.appName) === -1) {
            console.log("Error: you must provide an app name.");
            apps.forEach(function(app) {
                console.log("-", app);
            });
            return;
        }

        var entry = entryFromEnv(env);

        return merge(commonConfig, {
            entry: entry,

            devServer: {
                // serve index.html in place of 404 responses
                historyApiFallback: true,
                contentBase: "./src",
                headers: {
                    "Access-Control-Allow-Origin": "*",
                },
                stats: {
                    assets: false,
                    cached: false,
                    cachedAssets: false,
                    children: false,
                    chunks: false,
                    colors: true,
                    depth: true,
                    entrypoints: true,
                    errorDetails: true,
                    hash: false,
                    modules: true,
                    source: true,
                    timings: true,
                    version: false,
                    warnings: true,
                },
            },

            module: {
                rules: [
                    {
                        test: /\.(png|jpg|gif)$/,
                        use: [
                            {
                                loader: "url-loader",
                                options: {
                                    limit: 8192,
                                },
                            },
                        ],
                    },
                    {
                        test: /\.elm$/,
                        exclude: [/elm-stuff/, /node_modules/],
                        use: [
                            {
                                loader: "elm-hot-loader",
                            },
                            {
                                loader: "elm-webpack-loader",
                                options: {
                                    verbose: true,
                                    warn: true,
                                    debug: true,
                                },
                            },
                        ],
                    },
                ],
            },

            plugins: [new webpack.NamedModulesPlugin()],
        });
    };
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (isProd === true) {
    console.log("Building for prod...");

    module.exports = function(env) {
        if (!env || !env.appName || apps.indexOf(env.appName) === -1) {
            console.log("Error: you must provide an app name.");
            apps.forEach(function(app) {
                console.log("-", app);
            });
            return;
        }
        var entry = entryFromEnv(env);

        return merge(commonConfig, {
            entry: entry,

            module: {
                rules: [
                    {
                        test: /\.elm$/,
                        exclude: [/elm-stuff/, /node_modules/],
                        use: [
                            {
                                loader: "elm-webpack-loader",
                            },
                        ],
                    },
                ],
            },

            plugins: [
                // new CopyWebpackPlugin([
                //     {
                //         from: "src/static/img/",
                //         to: "static/img/",
                //     },
                //     {
                //         from: "src/favicon.ico",
                //     },
                // ]),

                new webpack.optimize.UglifyJsPlugin({
                    minimize: true,
                    compressor: { warnings: false },
                }),
            ],
        });
    };
}

var entryFromEnv = function(env) {
    var appName = env.appName;
    var entry = {};
    var sources;

    if (appName === "all") {
        sources = allApps;
    } else {
        sources = [appName];
    }

    sources.forEach(function(source) {
        var appSource = ["./js/index" + source + ".js"];
        entry[source] = appSource;
    });

    return entry;
};
