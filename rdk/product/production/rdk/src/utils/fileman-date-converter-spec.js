'use strict';

var filemanDateUtil = require('./fileman-date-converter');

describe('FilemanDateUtil', function() {
    describe('getThreeDigitYear', function() {
        it('return three digit year given a number year', function() {
            expect(filemanDateUtil.getThreeDigitYear(2014)).to.equal(314);
        });

        it('return -1 given a non-number year', function() {
            expect(filemanDateUtil.getThreeDigitYear('abc')).to.equal(-1);
        });

        it('return -1 given a negative year', function() {
            expect(filemanDateUtil.getThreeDigitYear(-2014)).to.equal(314);
        });
    });

    describe('getFilemanDate', function() {
        it('return string date in fileman format given a date object with double digit month', function() {
            var dateObject = new Date('October 13, 2014 11:13:00');
            expect(filemanDateUtil.getFilemanDate(dateObject)).to.equal('3141013');
        });

        it('return string date in fileman format given a date object with single digit month', function() {
            var dateObject = new Date('January 13, 2014 11:13:00');
            expect(filemanDateUtil.getFilemanDate(dateObject)).to.equal('3140113');
        });
    });

    describe('getFilemanDateTime', function() {
        it('return string date and time in fileman format given a date object', function() {
            var dateObject = new Date('October 13, 2014 11:13:56');
            expect(filemanDateUtil.getFilemanDateTime(dateObject)).to.equal('3141013.1113');
        });
    });
});
