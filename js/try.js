
'use strict';

var RRule = require('rrule').RRule;
var moment = require('./lib/moment-timezone-with-data.min.js');

var timezone = 'America/Los_Angeles';
var rfcString = "DTSTART=20150616T103000Z;FREQ=DAILY;BYHOUR=10;BYMINUTE=30;BYSECOND=0;UNTIL=20150712T153000Z";

/**
 * Calculate next recurrance 
 * @param  {Date}   fromDate    Date reference to calculate next recurrence.
 * @param  {String} rruleString Recurrence rule
 * @param  {String} tzid        Timezone names, using tz database.
 * @param  {Bool}   dateObj     returns Date Object if true.
 * @return {Number|Date}        Target date timestamp or object.
 */
// Time zones: http://www.iana.org/time-zones
function nextRecurrence(fromDate, rruleString, tzid, dateObj) {

  var rrule          = RRule.fromString(rruleString);

  // Timezone offset
  var timezone       = moment.tz.zone(tzid);
  var localOffset    = fromDate.getTimezoneOffset();
  var targetOffset   = timezone.offset(fromDate);
  var timezoneOffset = (localOffset - targetOffset) * 60 * 1000;

  // Do RRule calculation using server timezone.
  var adjustedFromDate   = new Date(fromDate.getTime() + timezoneOffset);
  var adjustedTargetDate = rrule.after(adjustedFromDate);

  // Switch back to target timezone
  var targetDate   = new Date(adjustedTargetDate.getTime() - timezoneOffset);

  // Taking DST switch into consideration
  if (targetOffset !== timezone.offset(targetDate) ||
      localOffset !== adjustedTargetDate.getTimezoneOffset()) {
    localOffset    = adjustedTargetDate.getTimezoneOffset();
    targetOffset   = timezone.offset(targetDate);
    timezoneOffset = (localOffset - targetOffset) * 60 * 1000;
    targetDate     = new Date(adjustedTargetDate - timezoneOffset);
  }

  return dateObj ? new Date(targetDate) : targetDate;
}

console.log('Target Date :', nextRecurrence(new Date(), rfcString, timezone, true));