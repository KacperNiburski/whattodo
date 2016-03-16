//React Library
React = require('react');
ReactDOM = require('react-dom');
//Material Design Library
MaterialUi = require('material-ui/lib');
injectTapEventPlugin = require('react-tap-event-plugin'); injectTapEventPlugin();
//Material Design Library Custom Theme
MyRawTheme = require('./theme');
ThemeManager = require('material-ui/lib/styles/theme-manager');

Components = {};

AppBar = require('material-ui/lib/app-bar');
TextField = require('material-ui/lib/text-field');

mui = require('material-ui');
Card = mui.Card
RaisedButton = mui.RaisedButton
CardText = mui.CardText

GridList = require('material-ui/lib/grid-list/grid-list');
GridTile = require('material-ui/lib/grid-list/grid-tile');
StarBorder = require('material-ui/lib/svg-icons/toggle/star-border');
IconButton = require('material-ui/lib/icon-button');