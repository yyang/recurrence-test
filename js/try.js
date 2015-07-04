
'use strict';

var Rrecur = require('rrecur').Rrecur;

// var rfcString = "DTSTART=20140616T103000Z;FREQ=DAILY;BYHOUR=10;BYMINUTE=30;BYSECOND=0";

// var rrule = Rrecur.parse(rfcString);

// rrule.dtstart = {utc: new Date(), locale: "GMT-0400 (EDT)"};

// console.log(rrule);

// var rrecur = Rrecur.create(rrule, new Date());

// var nextDate = rrecur.next();

// console.log(nextDate());
// 
var rrecur;

var rule = {
  freq: 'daily',
  // until: Rrecur.toAdjustedISOString(new Date(2014, 6, 22, 10, 30, 0), "GMT-0400 (EDT)"),
  count: 10,
  byhour: [10],
  byminute: [30],
  bysecond: [0],
  byday: ['mo', 'we', 'fr'] // Or [Rrecur.weekdays[1], Rrecur.weekdays[3], Rrecur.weekdays[5]]
// `bysecond` will default to 00, since that's what's specified in `dtstart`
};

console.log(Rrecur.stringify(rule));

var rfcString = "DTSTART=20150616T103000Z;FREQ=DAILY;BYHOUR=10;BYMINUTE=30;BYSECOND=0;UNTIL=20150712T153000Z";

rrecur = Rrecur.create({
  dtstart: {
    //zoneless: Rrecur.toLocaleISOString(new Date(2014, 6, 21, 10, 30, 0), "GMT-0400 (EDT)")
    utc: new Date(new Date().getTime()),
    locale: "+0800"
  },
  rrule: Rrecur.parse(rfcString)
}, new Date());

//console.log(rrecur);

console.log(rrecur.next()); // 2014-05-21T10:30:00.000-0400