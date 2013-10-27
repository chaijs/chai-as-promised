"use strict"

describe "Configuring the way in which promise-ness is transferred", =>
    savedTransferPromiseness = chaiAsPromised.transferPromiseness

    afterEach =>
        chaiAsPromised.transferPromiseness = savedTransferPromiseness

    it "should return a promise with the custom modifications applied", =>
        chaiAsPromised.transferPromiseness = (assertion, promise) =>
            assertion.then = promise.then.bind(promise)
            assertion.isCustomized = true

        promise = fulfilledPromise("1234")
        assertion = promise.should.become("1234")

        assertion.should.have.property("isCustomized", true)
