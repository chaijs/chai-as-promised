"use strict";

var chai = require("chai");
var chaiAsPromised = require("../..");
var Q = require("q");

chai.should();
chai.use(chaiAsPromised);

if (process.env.ENRICH_WITH === "Q") {
    chai.enrichPromiseWith("Q");
}

if (process.env.ENRICH_WITH === "CUSTOM") {
    chai.enrichPromiseWith(function (that, derivedPromise) {
        chai.promiseEnricher.then(that, derivedPromise);
        that.done = derivedPromise.done.bind(derivedPromise);
    });
}

global.expect = chai.expect;
global.AssertionError = chai.AssertionError;
global.Assertion = chai.Assertion;
global.assert = chai.assert;

global.fulfilledPromise = Q.resolve;
global.rejectedPromise = Q.reject;
global.defer = Q.defer;
