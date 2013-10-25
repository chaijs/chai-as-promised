<a href="http://promises-aplus.github.com/promises-spec">
    <img src="http://promises-aplus.github.com/promises-spec/assets/logo-small.png"
         align="right" valign="top" alt="Promises/A+ logo" />
</a>

# Chai Assertions for Promises

**Chai as Promised** extends [Chai][chai] with a fluent language for asserting facts about [promises][presentation].

Instead of manually wiring up your expectations to a promise's fulfilled and rejected handlers:

```javascript
doSomethingAsync().then(
    function (result) {
        result.should.equal("foo");
        done();
    },
    function (err) {
       done(err);
    }
);
```

you can write code that expresses what you really mean:

```javascript
doSomethingAsync().should.eventually.equal("foo").notify(done);
```

or if you have a testing framework that follows the [UncommonJS specification][uncommonjs] for handling promises,
simply

```javascript
return doSomethingAsync().should.eventually.equal("foo");
```

## How to Use

### `should`/`expect` Interface

The most powerful extension provided by Chai as Promised is the `eventually` property. With it, you can transform any
existing Chai assertion into one that acts on a promise:

```javascript
(2 + 2).should.equal(4);

// becomes
return promiseFor(2 + 2).should.eventually.equal(4);


expect({ foo: "bar" }).to.have.property("foo");

// becomes
return expect(promiseFor({ foo: "bar" })).to.eventually.have.property("foo");
```

There are also a few promise-specific extensions (with the usual `expect` equivalents also available):

```javascript
return promise.should.be.fulfilled;
return promise.should.eventually.deep.equal("foo");
return promise.should.become("foo"); // same as `.eventually.deep.equal`
return promise.should.be.rejected;
return promise.should.be.rejectedWith(Error); // other variants of Chai's `throw` assertion work too.
```

### `assert` Interface

As with the `should`/`expect` interface, Chai as Promised provides an `eventually` extender to `chai.assert`, allowing
any existing Chai assertion to be used on a promise:

```javascript
assert.equal(2 + 2, 4, "This had better be true");

// becomes
return assert.eventually.equal(promiseFor(2 + 2), 4, "This had better be true, eventually");
```

And there are, of course, promise-specific extensions:

```javascript
return assert.isFulfilled(promise, "optional message");

return assert.becomes(promise, "foo", "optional message");
return assert.doesNotBecome(promise, "foo", "optional message");

return assert.isRejected(promise, "optional message");
return assert.isRejected(promise, Error, "optional message");
return assert.isRejected(promise, /error message matcher/, "optional message");
```

### Progress Callbacks

Chai as Promised does not have any intrinsic support for testing promise progress callbacks. The properties you would
want to test are probably much better suited to a library like [Sinon.JS][sinon], perhaps in conjunction with
[Sinon–Chai][sinon-chai]:

```javascript
var progressSpy = sinon.spy();

return promise.then(null, null, progressSpy).then(function () {
    progressSpy.should.have.been.calledWith("33%");
    progressSpy.should.have.been.calledWith("67%");
    progressSpy.should.have.been.calledThrice;
});
```

### Working with Non-Promise–Friendly Test Runners

As mentioned, many test runners (\*cough\* [Mocha][mocha-makes-me-sad] \*cough\* … but see [Mocha as Promised][]!)
don't support the nice `return` style shown above. Instead, they take a callback indicating when the asynchronous test
run is over. Chai as Promised adapts to this situation with the `notify` method, like so:

```javascript
it("should be fulfilled", function (done) {
    promise.should.be.fulfilled.and.notify(done);
});

it("should be rejected", function (done) {
    otherPromise.should.be.rejected.and.notify(done);
});
```

In these examples, if the conditions are not met, the test runner will receive an error of the form `"expected promise
to be fulfilled but it was rejected with [Error: error message]"`, or `"expected promise to be rejected but it was
fulfilled."`

There's another form of `notify` which is useful in certain situations, like doing assertions after a promise is
complete. For example:

```javascript
it("should change the state", function (done) {
    otherState.should.equal("before");
    promise.should.be.fulfilled.then(function () {
        otherState.should.equal("after");
    }).should.notify(done);
});
```

Notice how `.notify(done)` is hanging directly off of `.should`, instead of appearing after a promise assertion. This
indicates to Chai as Promised that it should pass fulfillment or rejection directly through to the testing framework.
Thus, the above code will fail with a Chai as Promised error (`"expected promise to be fulfilled…"`) if `promise` is
rejected, but will fail with a simple Chai error (`expected "before" to equal "after"`) if `otherState` does not change.

Another example of where this can be useful is when performing assertions on multiple promises:

```javascript
it("should all be well", function (done) {
    Q.all([
        promiseA.should.become("happy"),
        promiseB.should.eventually.have.property("fun times"),
        promiseC.should.be.rejectedWith(TypeError, "only joyful types are allowed")
    ]).should.notify(done);
});
```

This will pass any failures of the individual promise assertions up to the test framework, instead of wrapping them in
an `"expected promise to be fulfilled…"` message as would happen if you did
`Q.all([…]).should.be.fulfilled.and.notify(done)`.

### Compatibility

Chai as Promised is compatible with all promises following the [Promises/A+ specification][spec]. Notably, jQuery's
so-called “promises” are not up to spec, and Chai as Promised will not work with them. In particular, Chai as Promised
makes extensive use of the standard [transformation behavior][] of `then`, which jQuery does not support.

### Customizing output promises

By default chai-as-promised are regular chai object extended with a single `then` 
method. To change this behaviour, for instance to output promise more in line 
with Q promise, use the `chai.promisifyWith`.

#### Q style

All the methods from the Q api will be available, except for `keys`, 
renamed to `qKeys`.

```js
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
chai.promisifyWith("Q");
```  

#### Custom method

```js
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
chai.promisifyWith(function (that, derivedPromise) {
  // that: the chai output object
  // derivedPromise: the input promise or a promise generated by calling
  // then on the input promise
  
  // reuse an existing promisify method ("default" or "Q")
  chai.promisifyMethods.default(that, derivedPromise);
  
  // extra customization
  that.done = derivedPromise.done.bind(derivedPromise);
  that.fin = derivedPromise.fin.bind(derivedPromise);
});

```  

## Installation and Setup

### Node

Do an `npm install chai-as-promised` to get up and running. Then:

```javascript
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");

chai.use(chaiAsPromised);
```

You can of course put this code in a common test fixture file; for an example using [Mocha][mocha], see
[the Chai as Promised tests themselves][fixturedemo].

### AMD

Chai as Promised supports being used as an [AMD][amd] module, registering itself anonymously (just like Chai). So,
assuming you have configured your loader to map the Chai and Chai as Promised files to the respective module IDs
`"chai"` and `"chai-as-promised"`, you can use them as follows:

```javascript
define(function (require, exports, module) {
    var chai = require("chai");
    var chaiAsPromised = require("chai-as-promised");

    chai.use(chaiAsPromised);
});
```

### `<script>` tag

If you include Chai as Promised directly with a `<script>` tag, after the one for Chai itself, then it will
automatically plug in to Chai and be ready for use:

```html
<script src="chai.js"></script>
<script src="chai-as-promised.js"></script>
```


[presentation]: http://www.slideshare.net/domenicdenicola/callbacks-promises-and-coroutines-oh-my-the-evolution-of-asynchronicity-in-javascript
[chai]: http://chaijs.com/
[mocha]: http://visionmedia.github.com/mocha/
[mocha-makes-me-sad]: https://github.com/visionmedia/mocha/pull/329
[Mocha as Promised]: https://github.com/domenic/mocha-as-promised
[uncommonjs]: http://kriskowal.github.com/uncommonjs/tests/specification
[spec]: http://promises-aplus.github.com/promises-spec/
[transformation behavior]: https://gist.github.com/3889970#that-second-paragraph
[fixturedemo]: https://github.com/domenic/chai-as-promised/tree/master/test/
[amd]: https://github.com/amdjs/amdjs-api/wiki/AMD
[sinon]: http://sinonjs.org/
[sinon-chai]: https://github.com/domenic/sinon-chai
