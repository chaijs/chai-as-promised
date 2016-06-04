"use strict"

describe "Stack traces", =>
    promise = null

    shouldFailWithCorrectStack = (promiseProducer) =>
        it "should return a promise rejected with an assertion error that has stack trace correct", (done) =>
            expect(promiseProducer().then(
                =>
                    throw new Error("promise fulfilled")
                (e) =>
                    e.stack.should.match(/stack-traces\.coffee/)
            )).to.be.fulfilled.notify(done)

    describe "eventually", =>
        beforeEach =>
            promise = fulfilledPromise(42)
            return undefined

        describe "assert", =>
            shouldFailWithCorrectStack => assert.eventually.equal(promise, 52)
        describe "expect", =>
            shouldFailWithCorrectStack => expect(promise).to.eventually.equal(52)
        describe "should", =>
            shouldFailWithCorrectStack => promise.should.eventually.equal(52)

    describe "fulfilled", =>
        beforeEach =>
            promise = rejectedPromise()
            return undefined

        describe "assert", =>
            shouldFailWithCorrectStack => assert.isFulfilled(promise)
        describe "expect", =>
            shouldFailWithCorrectStack => expect(promise).to.be.fulfilled
        describe "should", =>
            shouldFailWithCorrectStack => promise.should.be.fulfilled

    describe "rejected", =>
        beforeEach =>
            promise = fulfilledPromise()
            return undefined

        describe "assert", =>
            shouldFailWithCorrectStack => assert.isRejected(promise)
        describe "expect", =>
            shouldFailWithCorrectStack => expect(promise).to.be.rejected
        describe "should", =>
            shouldFailWithCorrectStack => promise.should.be.rejected

    describe "rejectedWith", =>
        beforeEach =>
            promise = rejectedPromise(TypeError())
            return undefined

        describe "assert", =>
            shouldFailWithCorrectStack => assert.isRejected(promise, ReferenceError)
        describe "expect", =>
            shouldFailWithCorrectStack => expect(promise).to.be.rejectedWith(ReferenceError)
        describe "should", =>
            shouldFailWithCorrectStack => promise.should.be.rejectedWith(ReferenceError)

    describe "multiple", =>
        beforeEach =>
            promise = fulfilledPromise({a: 42})
            return undefined

        describe "expect", =>
            shouldFailWithCorrectStack => expect(promise).to.eventually.have.property("a").that.equals(52)
        describe "should", =>
            shouldFailWithCorrectStack => promise.should.eventually.have.property("a").that.equals(52)
