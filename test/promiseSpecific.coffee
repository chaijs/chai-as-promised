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

    describe "rejected with a message substring:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(fulfilled.should.be.rejected.with("great")).to.be.rejected.with(AssertionError).then(done, done)

        describe "when the target promise is rejected", ->
            describe "with a reason having that substring in its message property", (done) ->
                rejected = null

                beforeEach ->
                    rejected = Q.reject(new Error("super great"))

                it "should return a fulfilled promise", (done) ->
                    expect(rejected.should.be.rejected.with("great")).to.be.fulfilled.then(done, done)

            describe "with a reason not containing that substring in its message property", (done) ->
                rejected = null

                beforeEach ->
                    rejected = Q.reject(new Error("no good"))

                it "should return a promise rejected with an assertion error", (done) ->
                    expect(rejected.should.be.rejected.with("great")).to.be.rejected.with(AssertionError)
                        .then(done, done)

    describe "not rejected with a message substring:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a fulflled promise", (done) ->
                expect(fulfilled.should.not.be.rejected.with("great")).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected", ->
            describe "with a reason having that substring in its message property", (done) ->
                rejected = null

                beforeEach ->
                    rejected = Q.reject(new Error("super great"))

                it "should return a promise rejected with an assertion error", (done) ->
                    expect(rejected.should.not.be.rejected.with("great")).to.be.rejected.with(AssertionError)
                        .then(done, done)

            describe "with a reason not containing that substring in its message property", (done) ->
                rejected = null

                beforeEach ->
                    rejected = Q.reject(new Error("no good"))

                it "should return a fulfilled promise", (done) ->
                    expect(rejected.should.not.be.rejected.with("great")).to.be.fulfilled.then(done, done)

    describe "rejected with a regular expression matcher:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(fulfilled.should.be.rejected.with(/great/)).to.be.rejected.with(AssertionError).then(done, done)

        describe "when the target promise is rejected", ->
            describe "with a reason having that substring in its message property", (done) ->
                rejected = null

                beforeEach ->
                    rejected = Q.reject(new Error("super great"))

                it "should return a fulfilled promise", (done) ->
                    expect(rejected.should.be.rejected.with(/great/)).to.be.fulfilled.then(done, done)

            describe "with a reason not containing that substring in its message property", (done) ->
                rejected = null

                beforeEach ->
                    rejected = Q.reject(new Error("no good"))

                it "should return a promise rejected with an assertion error", (done) ->
                    expect(rejected.should.be.rejected.with(/great/)).to.be.rejected.with(AssertionError)
                        .then(done, done)

    describe "not rejected with a regular expression matcher:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a fulflled promise", (done) ->
                expect(fulfilled.should.not.be.rejected.with(/great/)).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected", ->
            describe "with a reason having that substring in its message property", (done) ->
                rejected = null

                beforeEach ->
                    rejected = Q.reject(new Error("super great"))

                it "should return a promise rejected with an assertion error", (done) ->
                    expect(rejected.should.not.be.rejected.with(/great/)).to.be.rejected.with(AssertionError)
                        .then(done, done)

            describe "with a reason not containing that substring in its message property", (done) ->
                rejected = null

                beforeEach ->
                    rejected = Q.reject(new Error("no good"))

                it "should return a fulfilled promise", (done) ->
                    expect(rejected.should.not.be.rejected.with(/great/)).to.be.fulfilled.then(done, done)

    describe "rejected with Constructor and regular expression matcher:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(fulfilled.should.be.rejected.with(TypeError, /great/)).to.be.rejected.with(AssertionError)
                    .then(done, done)

        describe "when the target promise is rejected", ->
            error = null
            rejected = null

            describe "with a reason having the specified constructor", ->
                beforeEach ->
                    error = new TypeError
                    rejected = Q.reject(error)

                describe "and a matching message", ->
                    beforeEach ->
                        error.message = "super great"

                    it "should return a fulfilled promise", (done) ->
                        expect(rejected.should.be.rejected.with(TypeError, /great/)).to.be.fulfilled.then(done, done)

                describe "and a non-matching message", ->
                    beforeEach ->
                        error.message = "no good"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.be.rejected.with(TypeError, /great/)).to.be.rejected
                            .with(AssertionError).then(done, done)

            describe "with a reason having a different constructor", ->
                beforeEach ->
                    error = new Error
                    rejected = Q.reject(error)

                describe "but a matching message", ->
                    beforeEach ->
                        error.message = "super great"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.be.rejected.with(TypeError, /great/)).to.be.rejected
                            .with(AssertionError).then(done, done)

                describe "and a non-matching message", ->
                    beforeEach ->
                        error.message = "no good"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.be.rejected.with(TypeError, /great/)).to.be.rejected
                            .with(AssertionError).then(done, done)

    describe "not rejected with Constructor and regular expression matcher:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a fulfilled promise", (done) ->
                expect(fulfilled.should.not.be.rejected.with(TypeError, /great/)).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected", ->
            error = null
            rejected = null

            describe "with a reason having the specified constructor", ->
                beforeEach ->
                    error = new TypeError
                    rejected = Q.reject(error)

                describe "and a matching message", ->
                    beforeEach ->
                        error.message = "super great"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.not.be.rejected.with(TypeError, /great/)).to.be.rejected
                            .with(AssertionError).then(done, done)

                describe "and a non-matching message", ->
                    beforeEach ->
                        error.message = "no good"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.not.be.rejected.with(TypeError, /great/)).to.be.rejected
                            .with(AssertionError).then(done, done)

            describe "with a reason having a different constructor", ->
                beforeEach ->
                    error = new Error
                    rejected = Q.reject(error)

                describe "but a matching message", ->
                    beforeEach ->
                        error.message = "super great"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.not.be.rejected.with(TypeError, /great/)).to.be.rejected
                            .with(AssertionError).then(done, done)

                describe "and a non-matching message", ->
                    beforeEach ->
                        error.message = "no good"

                    it "should return a fulfilled promise", (done) ->
                        expect(rejected.should.not.be.rejected.with(TypeError, /great/)).to.be.fulfilled
                            .then(done, done)

    describe "rejected with Constructor and message substring:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(fulfilled.should.be.rejected.with(TypeError, /great/)).to.be.rejected.with(AssertionError)
                    .then(done, done)

        describe "when the target promise is rejected", ->
            error = null
            rejected = null

            describe "with a reason having the specified constructor", ->
                beforeEach ->
                    error = new TypeError
                    rejected = Q.reject(error)

                describe "and a message containing that substring", ->
                    beforeEach ->
                        error.message = "super great"

                    it "should return a fulfilled promise", (done) ->
                        expect(rejected.should.be.rejected.with(TypeError, "great")).to.be.fulfilled.then(done, done)

                describe "and a message not containing that substring", ->
                    beforeEach ->
                        error.message = "no good"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.be.rejected.with(TypeError, "great")).to.be.rejected
                            .with(AssertionError).then(done, done)

            describe "with a reason having a different constructor", ->
                beforeEach ->
                    error = new Error
                    rejected = Q.reject(error)

                describe "but a message containing that substring", ->
                    beforeEach ->
                        error.message = "super great"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.be.rejected.with(TypeError, "great")).to.be.rejected
                            .with(AssertionError).then(done, done)

                describe "and a message not containing that substring", ->
                    beforeEach ->
                        error.message = "no good"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.be.rejected.with(TypeError, "great")).to.be.rejected
                            .with(AssertionError).then(done, done)

    describe "not rejected with Constructor and message substring:", ->
        describe "when the target promise is fulfilled", ->
            it "should return a fulfilled promise", (done) ->
                expect(fulfilled.should.not.be.rejected.with(TypeError, "great")).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected", ->
            error = null
            rejected = null

            describe "with a reason having the specified constructor", ->
                beforeEach ->
                    error = new TypeError
                    rejected = Q.reject(error)

                describe "and a message containing that substring", ->
                    beforeEach ->
                        error.message = "super great"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.not.be.rejected.with(TypeError, "great")).to.be.rejected
                            .with(AssertionError).then(done, done)

                describe "and a message not containing that substring", ->
                    beforeEach ->
                        error.message = "no good"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.not.be.rejected.with(TypeError, "great")).to.be.rejected
                            .with(AssertionError).then(done, done)

            describe "with a reason having a different constructor", ->
                beforeEach ->
                    error = new Error
                    rejected = Q.reject(error)

                describe "but a message containing that substring", ->
                    beforeEach ->
                        error.message = "super great"

                    it "should return a promise rejected with an assertion error", (done) ->
                        expect(rejected.should.not.be.rejected.with(TypeError, "great")).to.be.rejected
                            .with(AssertionError).then(done, done)

                describe "and a message not containing that substring", ->
                    beforeEach ->
                        error.message = "no good"

                    it "should return a fulfilled promise", (done) ->
                        expect(rejected.should.not.be.rejected.with(TypeError, "great")).to.be.fulfilled
                            .then(done, done)

    describe "broken:", ->
        it "should be a synonym for rejected", ->
            rejectedGetter = Object.getOwnPropertyDescriptor(Assertion.prototype, "rejected").get
            brokenGetter = Object.getOwnPropertyDescriptor(Assertion.prototype, "broken").get

            expect(brokenGetter).to.equal(rejectedGetter)
