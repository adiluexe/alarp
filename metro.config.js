const { getDefaultConfig } = require("expo/metro-config");
const { withNativeWind } = require('nativewind/metro');

const config = getDefaultConfig(__dirname)
config.resolver.assetExts.push('obj', 'mtl');
module.exports = withNativeWind(config, { input: './app/globals.css' })