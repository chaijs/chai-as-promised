import * as chai from 'chai';
import chaiAsPromised from '../../lib/chai-as-promised.js';

chai.should();

// Just an example plugin used in tests. Has to be set here since
// plugins get loaded only once.
chai.use(({Assertion}, utils) => {
  Assertion.addMethod('pick', function (key) {
    const assertion = new Assertion(this._obj[key]);
    utils.transferFlags(this, assertion, false);
    return assertion;
  });
});

chai.use(chaiAsPromised);

process.on('unhandledRejection', () => {
  // Do nothing; we test these all the time.
});
process.on('rejectionHandled', () => {
  // Do nothing; we test these all the time.
});
