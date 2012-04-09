describe "Assert interface:", ->
    promise = null
    error = new Error("boo")

    describe "when the promise is fulfilled", ->
        beforeEach ->
            promise = Q.resolve()

        describe ".isFulfilled(promise)", ->
            shouldPass -> assert.isFulfilled(promise)

        describe ".isRejected(promise)", ->
            shouldFail -> assert.isRejected(promise)
        describe ".isRejected(promise, TypeError)", ->
            shouldFail -> assert.isRejected(promise, TypeError)
        describe ".isRejected(promise, /regexp/)", ->
            shouldFail -> assert.isRejected(promise, /regexp/)
        describe ".isRejected(promise, /regexp/)", ->
            shouldFail -> assert.isRejected(promise, TypeError, /regexp/)
        describe ".isRejected(promise, errorInstance)", ->
            shouldFail -> assert.isRejected(promise, error)

    describe "when the promise is rejected", ->
        beforeEach ->
            promise = Q.reject(error)

        describe ".isFulfilled", ->
            shouldFail -> assert.isFulfilled(promise)

        describe ".isRejected(promise, theError)", ->
            shouldPass -> assert.isRejected(promise, error)

        describe ".isRejected(promise, differentError)", ->
            shouldFail -> assert.isRejected(promise, new Error)

        describe "with an Error having message 'foo bar'", ->
            beforeEach ->
                promise = Q.reject(new Error("foo bar"))

            describe ".isRejected(promise, /bar/)", ->
                shouldPass -> assert.isRejected(promise, /bar/)

            describe ".isRejected(promise, /quux/)", ->
                shouldFail -> assert.isRejected(promise, /quux/)

        describe "with a RangeError", ->
            beforeEach ->
                promise = Q.reject(new RangeError)

            describe ".isRejected(promise, RangeError)", ->
                shouldPass -> assert.isRejected(promise, RangeError)
            describe ".isRejected(promise, TypeError)", ->
                shouldFail -> assert.isRejected(promise, TypeError)

    describe ".isBroken", ->
        it "should be a synonym for rejected", ->
            expect(assert.isBroken).to.equal(assert.isRejected)

    describe "Assertion messages", ->
        message = "No. I am your father."

        it "should be passed through for .isFulfilled(promise, message)", (done) ->
            expect(assert.isFulfilled(Q.reject(), message)).to.be.rejected.with(message).notify(done)

        it "should be passed through for .isRejected(promise, message)", (done) ->
            expect(assert.isRejected(Q.resolve(), message)).to.be.rejected.with(message).notify(done)

        it "should be passed through for .isRejected(promise, TypeError, message)", (done) ->
            expect(assert.isRejected(Q.resolve(), TypeError, message)).to.be.rejected.with(message).notify(done)

        it "should be passed through for .isRejected(promise, /regexp/, message)", (done) ->
            expect(assert.isRejected(Q.resolve(), /regexp/, message)).to.be.rejected.with(message).notify(done)
