describe "Promise-specific extensions:", ->
    promise = null
    error = new Error("boo")

    assertingDoneFactory = (done) ->
        (result) ->
            try
                expect(result).to.equal(error)
            catch assertionError
                return done(assertionError)

            done()

    describe "when the promise is fulfilled", ->
        beforeEach ->
            promise = fulfilledPromise()

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
        describe ".rejected.with(errorInstance)", ->
            shouldFail -> promise.should.be.rejected.with(error)

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
        describe ".not.rejected.with(errorInstance)", ->
            shouldPass -> promise.should.not.be.rejected.with(error)

        describe ".should.notify(done)", ->
            it "should pass the test", (done) ->
                promise.should.notify(done)

    describe "when the promise is rejected", ->
        beforeEach ->
            promise = rejectedPromise(error)

        describe ".fulfilled", ->
            shouldFail -> promise.should.be.fulfilled
        describe ".not.fulfilled", ->
            shouldPass -> promise.should.not.be.fulfilled

        describe ".rejected", ->
            shouldPass -> promise.should.be.rejected

        describe ".rejected.with(theError)", ->
            shouldPass -> promise.should.be.rejected.with(error)
        describe ".not.rejected.with(theError)", ->
            shouldFail -> promise.should.not.be.rejected.with(error)

        describe ".rejected.with(differentError)", ->
            shouldFail -> promise.should.be.rejected.with(new Error)
        describe ".not.rejected.with(differentError)", ->
            shouldPass -> promise.should.not.be.rejected.with(new Error)

        describe "with an Error having message 'foo bar'", ->
            beforeEach ->
                promise = rejectedPromise(new Error("foo bar"))

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
                promise = rejectedPromise(new RangeError)

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
                promise = rejectedPromise(new RangeError("foo bar"))

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

        describe ".should.notify(done)", ->
            it "should fail the test with the original error", (done) ->
                promise.should.notify(assertingDoneFactory(done))

    describe ".broken", ->
        it "should be a synonym for rejected", ->
            rejectedGetter = Object.getOwnPropertyDescriptor(Assertion.prototype, "rejected").get
            brokenGetter = Object.getOwnPropertyDescriptor(Assertion.prototype, "broken").get

            expect(brokenGetter).to.equal(rejectedGetter)

    describe ".should.notify with chaining (GH-3)", ->
        describe "the original promise is fulfilled", ->
            beforeEach -> promise = fulfilledPromise()

            describe "and the follow-up promise is fulfilled", ->
                beforeEach -> promise = promise.then(->)

                it "should pass the test", (done) ->
                    promise.should.notify(done)

            describe "but the follow-up promise is rejected", ->
                beforeEach -> promise = promise.then(-> throw error)

                it "should fail the test with the error from the follow-up promise", (done) ->
                    promise.should.notify(assertingDoneFactory(done))

        describe "the original promise is rejected", ->
            beforeEach -> promise = rejectedPromise(error)

            describe "but the follow-up promise is fulfilled", ->
                beforeEach -> promise = promise.then(->)

                it "should fail the test with the error from the original promise", (done) ->
                    promise.should.notify(assertingDoneFactory(done))

            describe "and the follow-up promise is rejected", ->
                beforeEach -> promise = promise.then(-> throw new Error("follow up"))

                it "should fail the test with the error from the original promise", (done) ->
                    promise.should.notify(assertingDoneFactory(done))

    describe "Attempts to use multiple Chai as Promised properties in an assertion", ->
        shouldTellUsNo = (func) ->
            it "should fail with an informative error message", ->
                expect(func).to.throw(Error, /Chai as Promised/)

        describe ".fulfilled.and.eventually.equal(42)", ->
            shouldTellUsNo -> fulfilledPromise(42).should.be.fulfilled.and.eventually.equal(42)
        describe ".fulfilled.and.become(42)", ->
            shouldTellUsNo -> fulfilledPromise(42).should.be.fulfilled.and.become(42)
        describe ".fulfilled.and.rejected", ->
            shouldTellUsNo -> fulfilledPromise(42).should.be.fulfilled.and.rejected

        describe ".rejected.and.eventually.equal(42)", ->
            shouldTellUsNo -> rejectedPromise(42).should.be.rejected.and.eventually.equal(42)
        describe ".rejected.and.become(42)", ->
            shouldTellUsNo -> rejectedPromise(42).should.be.rejected.and.become(42)
        describe ".rejected.and.fulfilled", ->
            shouldTellUsNo -> rejectedPromise(42).should.be.rejected.and.fulfilled
