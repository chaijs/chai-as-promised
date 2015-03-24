"use strict"

newMethod = () ->
    # Do nothing

newMethodChain = () ->
    this.assert this._obj.__property == true

makeFunction = () ->
    fn = () -> # Do nothing
    fn.__property = true
    return fn

chai.use (ctx) =>
    ctx.Assertion.addChainableMethod 'newMethod', newMethod, newMethodChain

describe "New method `newMethod` added to chai,", =>

    describe "before executing chai.use(chaiAsPromised)", =>
        it "should work", =>
            expect(makeFunction()).to.have.been.newMethod()

    describe "after executing chai.use(chaiAsPromised)", =>
        before =>
            chai.use chaiAsPromised

        it "should still work", =>
            expect(makeFunction()).to.have.been.newMethod()
