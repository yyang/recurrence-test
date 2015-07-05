
'use strict';

var RRule = require('rrule').RRule;
var moment = require('moment-timezone');

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
  /**
   * Calculate offset date with target timezone offset
   * @param  {Date}   localDate             Local Date, with desired date, hour, 
   *                                        minute, etc.
   * @param  {Number} targetTimezoneOffset  Timezone offset from UTC
   * @return {Date}                  A new timestamp in target timezone with same
   *                                 date composition.
   */
  function offsetDate(localDateTimestamp, targetTimezoneOffset) {
    var localOffset = new Date().getTimezoneOffset();
    return localDateTimestamp - (localOffset - targetTimezoneOffset) * 60 * 1000;
  }

  var rrule    = RRule.fromString(rruleString);
  var timezone = moment.tz.zone(tzid);


  var localDate    = rrule.after(fromDate).getTime();
  var targetOffset = timezone.offset(localDate);
  var targetDate   = offsetDate(localDate, targetOffset);

  if (targetOffset !== timezone.offset(targetDate)) {
    targetOffset = timezone.offset(targetDate);
    targetDate   = offsetDate(localDate, targetOffset);
  }

  return dateObj ? new Date(targetDate) : targetDate;
}

console.log('Target Date :', nextRecurrence(new Date(), rfcString, timezone, true));