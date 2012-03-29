var chai = require("chai");
var promisedChai = require("..");
var Q = require("q");

chai.should();
chai.use(promisedChai);

global.expect = chai.expect;
global.AssertionError = chai.AssertionError;
global.Assertion = chai.Assertion;
global.Q = Q;
