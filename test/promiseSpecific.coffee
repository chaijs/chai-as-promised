describe "Promise-specific extensions:", ->
    fulfilled = null
    rejected = null

    beforeEach ->
        fulfilled = Q.resolve("foo")
        rejected = Q.reject(new Error())

    describe "fulfilled:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a fulfilled promise", (done) ->
                expect(fulfilled.should.be.fulfilled).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejected.should.be.fulfilled).to.be.rejected.with(AssertionError).then(done, done)

    describe "not fulfilled:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(fulfilled.should.not.be.fulfilled).to.be.rejected.with(AssertionError).then(done, done)

        describe "when the target promise is rejected", ->
            it "should return a fulfilled promise", (done) ->
                expect(rejected.should.not.be.fulfilled).to.be.fulfilled.then(done, done)

    describe "rejected:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(fulfilled.should.be.rejected).to.be.rejected.with(AssertionError).then(done, done)

        describe "when the target promise is rejected", ->
            it "should return a fulfilled promise", (done) ->
                expect(rejected.should.be.rejected).to.be.fulfilled.then(done, done)

    describe "not rejected:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a fulfilled promise", (done) ->
                expect(fulfilled.should.not.be.rejected).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejected.should.not.be.rejected).to.be.rejected.with(AssertionError).then(done, done)

    describe "rejected with Constructor:", ->
        rejectedTypeError = null

        beforeEach ->
            rejectedTypeError = Q.reject(new TypeError())

        describe "when the target promise is fulfilled", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(fulfilled.should.be.rejected.with(TypeError)).to.be.rejected.with(AssertionError)
                    .then(done, done)

        describe "when the target promise is rejected with a reason having the correct constructor", ->
            it "should return a fulfilled promise", (done) ->
                expect(rejectedTypeError.should.be.rejected.with(TypeError)).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected with a reason having the wrong constructor", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejected.should.be.rejected.with(TypeError)).to.be.rejected.with(AssertionError)
                    .then(done, done)

    describe "not rejected with Constructor:", ->
        rejectedTypeError = null

        beforeEach ->
            rejectedTypeError = Q.reject(new TypeError())

        describe "when the target promise is fulfilled", ->
            it "should return a fulfilled promise", (done) ->
                expect(fulfilled.should.not.be.rejected.with(TypeError)).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected with a reason having the specified constructor", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejectedTypeError.should.not.be.rejected.with(TypeError)).to.be.rejected.with(AssertionError)
                    .then(done, done)

        describe "when the target promise is rejected with a reason having a different constructor", ->
            it "should return a fulfilled promise", (done) ->
                expect(rejected.should.not.be.rejected.with(TypeError)).to.be.fulfilled.then(done, done)

    describe "rejected with Constructor and regular expression matcher:", ->
        rejectedTypeError = null
        rejectedMatchingTypeError = null
        rejectedMatchingError = null

        beforeEach ->
            rejectedTypeError = Q.reject(new TypeError("no good"))
            rejectedMatchingTypeError = Q.reject(new TypeError("great"))
            rejectedMatchingError = Q.reject(new Error("great"))

        describe "when the target promise is fulfilled", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(fulfilled.should.be.rejected.with(TypeError, /great/)).to.be.rejected.with(AssertionError)
                    .then(done, done)

        describe "when the target promise is rejected with a reason having the specified constructor and a matching " +
                 "message", ->
            it "should return a fulfilled promise", (done) ->
                expect(rejectedMatchingTypeError.should.be.rejected.with(TypeError, /great/)).to.be.fulfilled
                    .then(done, done)

        describe "when the target promise is rejected with a reason having the specified constructor but a " +
                 "non-matching message", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejectedTypeError.should.be.rejected.with(TypeError, /great/)).to.be.rejected
                    .with(AssertionError).then(done, done)

        describe "when the target promise is rejected with a reason having a different constructor but a matching " +
                 "message", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejectedMatchingError.should.be.rejected.with(TypeError, /great/)).to.be.rejected
                    .with(AssertionError).then(done, done)

        describe "when the target promise is rejected with a reason having a different constructor and a " + 
                 "non-matching message", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejected.should.be.rejected.with(TypeError, /great/)).to.be.rejected.with(AssertionError)
                    .then(done, done)

    describe "not rejected with Constructor and regular expression matcher:", ->
        rejectedTypeError = null
        rejectedMatchingTypeError = null
        rejectedMatchingError = null

        beforeEach ->
            rejectedTypeError = Q.reject(new TypeError("no good"))
            rejectedMatchingTypeError = Q.reject(new TypeError("great"))
            rejectedMatchingError = Q.reject(new Error("great"))

        describe "when the target promise is fulfilled", ->
            it "should return a fulfilled promise", (done) ->
                expect(fulfilled.should.not.be.rejected.with(TypeError, /great/)).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected with a reason having the specified constructor and a matching " +
                 "message", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejectedMatchingTypeError.should.not.be.rejected.with(TypeError, /great/)).to.be.rejected
                    .with(AssertionError).then(done, done)

        describe "when the target promise is rejected with a reason having the specified constructor but a " +
                 "non-matching message", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejectedTypeError.should.not.be.rejected.with(TypeError, /great/)).to.be.rejected
                    .with(AssertionError).then(done, done)

        describe "when the target promise is rejected with a reason having a different constructor but a matching " +
                 "message", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejectedMatchingError.should.not.be.rejected.with(TypeError, /great/)).to.be.rejected
                    .with(AssertionError).then(done, done)

        describe "when the target promise is rejected with a reason having a different constructor and a " + 
                 "non-matching message", ->
            it "should return a fulfilled promise", (done) ->
                expect(rejected.should.not.be.rejected.with(TypeError, /great/)).to.be.fulfilled.then(done, done)

    describe "broken:", ->
        it "should be a synonym for rejected", ->
            rejectedGetter = Object.getOwnPropertyDescriptor(Assertion.prototype, "rejected").get
            brokenGetter = Object.getOwnPropertyDescriptor(Assertion.prototype, "broken").get

            expect(brokenGetter).to.equal(rejectedGetter)
