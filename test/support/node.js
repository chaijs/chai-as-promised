"use strict";

var chai = require("chai");
var chaiAsPromised = require("../..");
var Q = require("q");

chai.should();
chai.use(chaiAsPromised);

if (process.env.PROMISIFY_WITH === "Q") {
    chai.promisifyWith("Q");
}

if (process.env.PROMISIFY_WITH === "CUSTOM") {
    chai.promisifyWith(function (that, derivedPromise) {
        chai.promisifyMethods.default(that, derivedPromise);
        that.done = derivedPromise.done.bind(derivedPromise);
        that.fin = derivedPromise.fin.bind(derivedPromise);
    });
}

global.expect = chai.expect;
global.AssertionError = chai.AssertionError;
global.Assertion = chai.Assertion;
global.assert = chai.assert;

global.fulfilledPromise = Q.resolve;
global.rejectedPromise = Q.reject;
global.defer = Q.defer;
