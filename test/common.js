var chai = require("chai");
var promisedChai = require("..");
var Q = require("Q");

chai.should();
chai.use(promisedChai);

global.expect = chai.expect;
global.AssertionError = chai.AssertionError;
global.Assertion = chai.Assertion;
global.Q = Q;
