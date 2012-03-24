shouldPass = (promiseProducer) ->
    it "should return a fulfilled promise", (done) ->
        expect(promiseProducer()).to.be.fulfilled.then(done, done)

shouldFail = (promiseProducer) ->
    it "should return a promise rejected with an assertion error", (done) ->
        expect(promiseProducer()).to.be.rejected.with(AssertionError).then(done, done)

describe "Promise-specific extensions:", ->
    promise = null

    describe "when the promise is fulfilled", ->
        beforeEach ->
            promise = Q.resolve()

        describe ".fulfilled", ->
            shouldPass -> promise.should.be.fulfilled
        describe ".not.fulfilled", ->
            shouldFail -> promise.should.not.be.fulfilled

        describe ".rejected", ->
            shouldFail -> promise.should.be.rejected
        describe ".rejected.with(TypeError)", ->
            shouldFail -> promise.should.be.rejected.with(TypeError)
        describe ".rejected.with('message substring')", ->
            shouldFail -> promise.should.be.rejected.with("message substring")
        describe ".rejected.with(/regexp/)", ->
            shouldFail -> promise.should.be.rejected.with(/regexp/)
        describe ".rejected.with(TypeError, 'message substring')", ->
            shouldFail -> promise.should.be.rejected.with(TypeError, "message substring")
        describe ".rejected.with(TypeError, /regexp/)", ->
            shouldFail -> promise.should.be.rejected.with(TypeError, /regexp/)

        describe ".not.rejected", ->
            shouldPass -> promise.should.not.be.rejected
        describe ".not.rejected.with(TypeError)", ->
            shouldPass -> promise.should.not.be.rejected.with(TypeError)
        describe ".not.rejected.with('message substring')", ->
            shouldPass -> promise.should.not.be.rejected.with("message substring")
        describe ".not.rejected.with(/regexp/)", ->
            shouldPass -> promise.should.not.be.rejected.with(/regexp/)
        describe ".not.rejected.with(TypeError, 'message substring')", ->
            shouldPass -> promise.should.not.be.rejected.with(TypeError, "message substring")
        describe ".not.rejected.with(TypeError, /regexp/)", ->
            shouldPass -> promise.should.not.be.rejected.with(TypeError, /regexp/)

    describe "when the promise is rejected", ->
        beforeEach ->
            promise = Q.reject(new Error)

        describe ".fulfilled", ->
            shouldFail -> promise.should.be.fulfilled
        describe ".not.fulfilled", ->
            shouldPass -> promise.should.not.be.fulfilled

        describe "with an error having message 'foo bar'", ->
            beforeEach ->
                promise = Q.reject(new Error("foo bar"))

            describe ".rejected.with('foo')", ->
                shouldPass -> promise.should.be.rejected.with("foo")
            describe ".rejected.with(/bar/)", ->
                shouldPass -> promise.should.be.rejected.with(/bar/)

            describe ".rejected.with('quux')", ->
                shouldFail -> promise.should.be.rejected.with("quux")
            describe ".rejected.with(/quux/)", ->
                shouldFail -> promise.should.be.rejected.with(/quux/)


            describe ".not.rejected.with('foo')", ->
                shouldFail -> promise.should.not.be.rejected.with("foo")
            describe ".not.rejected.with(/bar/)", ->
                shouldFail -> promise.should.not.be.rejected.with(/bar/)

            describe ".not.rejected.with('quux')", ->
                shouldPass -> promise.should.not.be.rejected.with("quux")
            describe ".not.rejected.with(/quux/)", ->
                shouldPass -> promise.should.not.be.rejected.with(/quux/)

        describe "with a RangeError", ->
            beforeEach ->
                promise = Q.reject(new RangeError)

            describe ".rejected.with(RangeError)", ->
                shouldPass -> promise.should.be.rejected.with(RangeError)
            describe ".rejected.with(TypeError)", ->
                shouldFail -> promise.should.be.rejected.with(TypeError)

            describe ".not.rejected.with(RangeError)", ->
                shouldFail -> promise.should.not.be.rejected.with(RangeError)
            describe ".not.rejected.with(TypeError)", ->
                shouldPass -> promise.should.not.be.rejected.with(TypeError)

        describe "with a RangeError having a message 'foo bar'", ->
            beforeEach ->
                promise = Q.reject(new RangeError("foo bar"))

            describe ".rejected.with(RangeError, 'foo')", ->
                shouldPass -> promise.should.be.rejected.with(RangeError, "foo")
            describe ".rejected.with(RangeError, /bar/)", ->
                shouldPass -> promise.should.be.rejected.with(RangeError, /bar/)

            describe ".rejected.with(RangeError, 'quux')", ->
                shouldFail -> promise.should.be.rejected.with(RangeError, "quux")
            describe ".rejected.with(RangeError, /quux/)", ->
                shouldFail -> promise.should.be.rejected.with(RangeError, /quux/)

            describe ".rejected.with(TypeError, 'foo')", ->
                shouldFail -> promise.should.be.rejected.with(TypeError, "foo")
            describe ".rejected.with(TypeError, /bar/)", ->
                shouldFail -> promise.should.be.rejected.with(TypeError, /bar/)

            describe ".rejected.with(TypeError, 'quux')", ->
                shouldFail -> promise.should.be.rejected.with(TypeError, "quux")
            describe ".rejected.with(TypeError, /quux/)", ->
                shouldFail -> promise.should.be.rejected.with(TypeError, /quux/)


            describe ".not.rejected.with(RangeError, 'foo')", ->
                shouldFail -> promise.should.not.be.rejected.with(RangeError, "foo")
            describe ".not.rejected.with(RangeError, /bar/)", ->
                shouldFail -> promise.should.not.be.rejected.with(RangeError, /bar/)

            describe ".not.rejected.with(RangeError, 'quux')", ->
                shouldFail -> promise.should.not.be.rejected.with(RangeError, "quux")
            describe ".not.rejected.with(RangeError, /quux/)", ->
                shouldFail -> promise.should.not.be.rejected.with(RangeError, /quux/)

            describe ".not.rejected.with(TypeError, 'foo')", ->
                shouldFail -> promise.should.not.be.rejected.with(TypeError, "foo")
            describe ".not.rejected.with(TypeError, /bar/)", ->
                shouldFail -> promise.should.not.be.rejected.with(TypeError, /bar/)

            describe ".not.rejected.with(TypeError, 'quux')", ->
                shouldPass -> promise.should.not.be.rejected.with(TypeError, "quux")
            describe ".not.rejected.with(TypeError, /quux/)", ->
                shouldPass -> promise.should.not.be.rejected.with(TypeError, /quux/)

    describe ".broken", ->
        it "should be a synonym for rejected", ->
            rejectedGetter = Object.getOwnPropertyDescriptor(Assertion.prototype, "rejected").get
            brokenGetter = Object.getOwnPropertyDescriptor(Assertion.prototype, "broken").get

            expect(brokenGetter).to.equal(rejectedGetter)
