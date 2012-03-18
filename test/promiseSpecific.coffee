describe "Promise-specific extensions", ->
    fulfilled = null
    rejected = null

    beforeEach ->
        fulfilled = Q.resolve("foo")
        rejected = Q.reject(new Error())

    describe "fulfilled", ->
        it "should return a fulfilled promise when the target promise is fulfilled", (done) ->
            fulfilled.should.be.fulfilled.then(
                -> done(),
                -> done(new Error("Should not have been rejected"))
            )

        it "should return a promise rejected with an assertion error when the target promise is rejected", (done) ->
            rejected.should.be.fulfilled.then(
                -> done(new Error("Should not have been fulfilled")),
                (error) ->
                    error.should.be.an.instanceOf(AssertionError)
                    done()
            )

        it "should be usable with `.then(done, done)`", (done) ->
            fulfilled.should.be.fulfilled.then(done, done)

    describe "not fulfilled", ->
        it "should return a fulfilled promise when the target promise is rejected", (done) ->
            rejected.should.not.be.fulfilled.then(
                -> done(),
                -> done(new Error("Should not have been rejected"))
            )

        it "should return a promise rejected with an assertion error when the target promise is fulfilled", (done) ->
            fulfilled.should.not.be.fulfilled.then(
                -> done(new Error("Should not have been fulfilled")),
                (error) ->
                    error.should.be.an.instanceOf(AssertionError)
                    done()
            )

    testRejected = (name) ->
        describe name, ->
            it "should return a fulfilled promise when the target promise is rejected", (done) ->
                rejected.should.be[name].then(
                    -> done(),
                    -> done(new Error("Should not have been rejected"))
                )

            it "should return a promise rejected with an assertion error when the target promise is fulfilled", (done) ->
                fulfilled.should.be[name].then(
                    -> done(new Error("Should not have been fulfilled")),
                    (error) ->
                        error.should.be.an.instanceOf(AssertionError)
                        done()
                )

        describe "not #{ name }", ->
            it "should return a fulfilled promise when the target promise is fulfilled", (done) ->
                fulfilled.should.not.be[name].then(
                    -> done(),
                    -> done(new Error("Should not have been rejected"))
                )

            it "should return a promise rejected with an assertion error when the target promise is rejected", (done) ->
                rejected.should.not.be[name].then(
                    -> done(new Error("Should not have been fulfilled")),
                    (error) ->
                        error.should.be.an.instanceOf(AssertionError)
                        done()
                )

        describe "#{ name }.with(Constructor)", ->
            rejectedTypeError = null

            beforeEach ->
                rejectedTypeError = Q.reject(new TypeError())

            it "should return a fulfilled promise when the target promise is rejected with a reason having the correct " +
               "constructor", ->
                rejectedTypeError.should.be[name].with(TypeError).then(
                    -> done(),
                    -> done(new Error("Should not have been rejected"))
                )

            it "should return a promise rejected with an assertion error when the target promise is rejected with a " +
               "reason having the wrong constructor", ->
                rejected.should.be[name].with(TypeError).then(
                    -> done(new Error("Should not have been fulfilled")),
                    (error) ->
                        error.should.be.an.instanceOf(AssertionError)
                        done()
                )

    testRejected("rejected")
    testRejected("broken")
