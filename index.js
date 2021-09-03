//const runtime = require("@objj/runtime");
const path = require("path");

const ojTestFrameworkPath = path.join(__dirname, "Frameworks");

exports.pathToOJTest = path.join(__dirname, "src", "ojtest.j");

global.OBJJ_INCLUDE_PATHS.push(ojTestFrameworkPath);
