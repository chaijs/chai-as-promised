"use strict";

exports.shouldPass = promiseProducer => {
    it("should return a fulfilled promise", done => {
        promiseProducer().then(
            () => done(),
            reason => done(new Error(`Expected promise to be fulfilled but it was rejected with ${reason.stack}`))
        );
    });
};

exports.shouldFail = options => {
    const promiseProducer = options.op;
    const desiredMessageSubstring = options.message;
    const nonDesiredMessageSubstring = options.notMessage;
    const desiredStackSubstring = options.stack;

    it("should return a promise rejected with an assertion error", done => {
        promiseProducer().then(
            () => {
                throw new Error("Expected promise to be rejected with an assertion error, but it was fulfilled");
            },
            reason => {
                if (Object(reason) !== reason || reason.constructor.name !== "AssertionError") {
                    throw new Error(`Expected promise to be rejected with an AssertionError but it was rejected ` +
                                    `with ${reason}`);
                }

                if (desiredMessageSubstring && !reason.message.includes(desiredMessageSubstring)) {
                    throw new Error(`Expected promise to be rejected with an AssertionError containing ` +
                                    `"${desiredMessageSubstring}" but it was rejected with ${reason}`);
                }

                if (nonDesiredMessageSubstring && reason.message.includes(nonDesiredMessageSubstring)) {
                    throw new Error(`Expected promise to be rejected with an AssertionError not containing ` +
                                    `"${nonDesiredMessageSubstring}" but it was rejected with ${reason}`);
                }

                if (desiredStackSubstring && !reason.stack.includes(desiredStackSubstring)) {
                    throw new Error(`Expected promise to be rejected with an AssertionError with a stack containing ` +
                                    `"${desiredStackSubstring}" but it was rejected with ${reason}: ${reason.stack}`);
                }
            }
        ).then(done, done);
    });
};
