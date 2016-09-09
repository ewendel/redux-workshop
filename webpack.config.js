var path = require('path');
var webpack = require('webpack');

module.exports = {
  devtool: 'cheap-module-eval-source-map',
  entry: [
    'webpack-hot-middleware/client',
    './src/index'
  ],
  output: {
    path: path.join(__dirname, 'public'),
    filename: 'bundle.js',
    publicPath: '/public/'
  },
  plugins: [
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ],
  module: {
    loaders: [{
      test: /\.elm$/,
      loader: 'elm-hot!elm-webpack',
      exclude: [/node_modules/, /elm-stuff/],
      include: __dirname
    }],
    noParse: /\.elm$/
  },
  resolve: {
    extensions: ['', '.js', '.elm']
  }
};
