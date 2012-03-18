Chai Assertions for Working with Promises
=========================================

**Promised Chai** extends [Chai][chai] with a fluent language for asserting facts about [promises][presentation].

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
doSomethingAsync().should.eventually.equal("foo").then(done, done);
```

or if you have a testing framework that follows the [UncommonJS specification][uncommonjs] for handling promises,
simply

```javascript
return doSomethingAsync().should.eventually.equal("foo");
```

## How to Use

The most powerful extension provided by Promised Chai is the `eventually` property. With it, you can transform any
existing Chai assertion into one that acts on a promise:

```javascript
(2 + 2).should.equal(4);

return promiseFor(2 + 2).should.eventually.equal(4);

({ foo: "bar" }).should.have.property("foo");

// becomes
return promiseFor({ foo: "bar" }).should.eventually.have.property("foo");


(function () { throw new Error(); }).should.throw(Error);

// becomes
return rejectedPromise(new Error()).should.eventually.throw(Error);
```

There are also a number of promise-specific extensions, grouped here as synonymic blocks:

```javascript
return promise.should.be.fulfilled;

return promise.should.be.rejected;
return promise.should.be.broken;

return promise.should.eventually.eql("foo");
return promise.should.become("foo");
return promise.should.be.fulfilled.with("foo");

// Other variants of Chai's existing `throw` assertion work too:
return promise.should.eventually.throw(Error);
return promise.should.be.rejected.with(Error);
return promise.should.be.broken.with(Error);

// `be.fulfilled.to` is a synonym for `eventually`:
return promise.should.eventually.be.within(5, 10);
return promise.should.be.fulfilled.to.be.within(5, 10);
```

## Installation and Usage

### Node

Do an `npm install promised-chai` to get up and running. Then:

```javascript
var chai = require("chai");
var promisedChai = require("promised-chai");

chai.use(promisedChai);
```

You can of course put this code in a common test fixture file; for an example using [Mocha][mocha], see
[the Promised Chai tests themselves][fixturedemo].

### AMD

Promised Chai supports being used as an [AMD][amd] module, registering itself anonymously (just like Chai). So,
assuming you have configured your loader to map the Chai and Promised Chai files to the respective module IDs `"chai"`
and `"promised-chai"`, you can use them as follows:

```javascript
define(function (require, exports, module) {
    var chai = require("chai");
    var promisedChai = require("promised-chai");

    chai.use(promisedChai);
});
```

### `<script>` tag

If you include Promised Chai directly with a `<script>` tag, it creates a `window.promisedChai` global (again, just
like Chai). Then your setup code becomes:

```javascript
window.chai.use(window.promisedChai);
```


[presentation]: http://www.slideshare.net/domenicdenicola/callbacks-promises-and-coroutines-oh-my-the-evolution-of-asynchronicity-in-javascript
[chai]: http://chaijs.com/
[uncommonjs]: http://kriskowal.github.com/uncommonjs/tests/specification
[fixturedemo]: https://github.com/domenic/promised-chai/tree/master/test/
[amd]: https://github.com/amdjs/amdjs-api/wiki/AMD
