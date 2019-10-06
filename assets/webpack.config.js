const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: {
    app: ['./js/app.js'],
    author: ['whatwg-fetch', './src/author.tsx']
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  resolve: {
    
    extensions: ['.ts', '.tsx', '.js', '.jss'],
    // Add webpack aliases for top level imports
    alias: {
        actions: path.resolve(__dirname, 'src/actions'),
        components: path.resolve(__dirname, 'src/components'),
        data: path.resolve(__dirname, 'src/data'),
        editors: path.resolve(__dirname, 'src/editors'),
        reducers: path.resolve(__dirname, 'src/reducers'),
        styles: path.resolve(__dirname, 'src/styles'),
        stylesheets: path.resolve(__dirname, 'src/stylesheets'),
        types: path.resolve(__dirname, 'src/types'),
        utils: path.resolve(__dirname, 'src/utils'),
    },
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader']
      },
      { test: /\.(png|gif|jpg|jpeg|svg)$/, use: 'file-loader' },
      { test: /\.ts$/, use: ['babel-loader', 'ts-loader'], exclude: /node_modules/ },
      {
        test: /\.tsx$/, use: [
            {
                loader: 'babel-loader',
                options: {
                    // This is a feature of `babel-loader` for webpack (not Babel itself).
                    // It enables caching results in ./node_modules/.cache/babel-loader/
                    // directory for faster rebuilds.
                    cacheDirectory: true
                },
            },
            { loader: 'ts-loader' }
        ], exclude: /node_modules/
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }])
  ]
});
