'use strict';

var fetchList = require('./lab-order-max-days-continuous-fetch-list').getLabOrderMaxDaysContinuous;

var log = sinon.stub(require('bunyan').createLogger({ name: 'lab-order-max-days-continuous-fetch-list' }));
//var log = require('bunyan').createLogger({ name: 'lab-order-max-days-continuous-fetch-list' }); //Uncomment this line (and comment above) to see output in IntelliJ console

var configuration = {
    environment: 'development',
    context: 'OR CPRS GUI CHART',
    host: '10.2.2.101',
    port: 9210,
    accessCode: 'pu1234',
    verifyCode: 'pu1234!!',
    localIP: '10.2.2.1',
    localAddress: 'localhost'
};

describe('lab-order-max-days-continuous resource integration test', function() {
    it('can call the getLabOrderMaxDaysContinuous RPC', function (done) {
        this.timeout(20000);
        fetchList(log, configuration, 11, 0, function(err, result) {
            expect(err).to.be.falsy();
            expect(result).to.be.truthy();
            done();
        });
    });

    it('will handle finding zero data with the getLabOrderMaxDaysContinuous RPC', function (done) {
        this.timeout(20000);
        fetchList(log, configuration, 0, 0, function(err, result) {
            expect(err).to.be.falsy();
            expect(result).to.be.truthy();
            expect(result.value).to.equal(-1);
            done();
        });
    });
});