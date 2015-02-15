"use strict"

describe "Configuring the way in which asserter arguments are transformed", =>
    transformAsserterArgs = chaiAsPromised.transformAsserterArgs

    beforeEach =>
      chaiAsPromised.transformAsserterArgs = waitAll

    afterEach =>
        chaiAsPromised.transformAsserterArgs = transformAsserterArgs

    it "should override transformAsserterArgs and allow to compare promises", =>
        value = "test it"

        fulfilledPromise(value).should.eventually.equal(fulfilledPromise(value))

    it "should override transformAsserterArgs and wait until all promises are resolved", =>
        fulfilledPromise(5).should.eventually.be.within(fulfilledPromise(3), fulfilledPromise(6))

    it "should not invoke transformAsserterArgs for chai properties", =>
        chaiAsPromised.transformAsserterArgs = =>
            throw new Error("transformAsserterArgs should not be called for chai properties")

        fulfilledPromise(true).should.eventually.be.true

