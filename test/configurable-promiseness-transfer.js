import './support/setup.js';
import {setTransferPromiseness} from '../lib/chai-as-promised.js';

describe('Configuring the way in which promise-ness is transferred', () => {
  afterEach(() => {
    setTransferPromiseness(null);
  });

  it('should return a promise with the custom modifications applied', () => {
    setTransferPromiseness((assertion, promise) => {
      assertion.then = promise.then.bind(promise);
      assertion.isCustomized = true;
    });

    const promise = Promise.resolve('1234');
    const assertion = promise.should.become('1234');

    assertion.should.have.property('isCustomized', true);
  });
});
