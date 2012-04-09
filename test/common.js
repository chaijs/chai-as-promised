var chai = require("chai");
var promisedChai = require("..");
var Q = require("q");

chai.should();
chai.use(promisedChai);

global.expect = chai.expect;
global.AssertionError = chai.AssertionError;
global.Assertion = chai.Assertion;
global.assert = chai.assert;
global.Q = Q;

global.shouldPass = function (promiseProducer) {
    it("should return a fulfilled promise", function (done) {
        expect(promiseProducer()).to.be.fulfilled.notify(done);
    });
};

global.shouldFail = function (promiseProducer) {
    it("should return a promise rejected with an assertion error", function (done) {
        expect(promiseProducer()).to.be.rejected.with(AssertionError).notify(done);
    });
};
