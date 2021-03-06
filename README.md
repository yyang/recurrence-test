RFC2445 Test
============

We found it's very difficult to deal with recurrence on multiple platforms, 
especially when JavaScript exists. Therefore we tested a few open source
packages and came up with solution as following:

JavaScript
----------

We use `RRule` to manage recurrence, `moment-timezone` to deal with timezone.

The method would shift time from target timezone to local timezone (to keep 
target date components), and do recurrence rule based calculation. After such 
calculation it would shift back to the local timezone (considering possible
DST shift).


Objective-C
-----------

Inspired by [[ https://github.com/FabienDiTore/ios-rrule_parser ]], we 
implemented a homebrew class called `RRule`.

The current method lacks some dataset support. Needs improvement.


Cases
-----
```
FREQ=MONTHLY;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-1
FREQ=YEARLY;INTERVAL=2;BYMONTH=1;BYDAY=SU;BYHOUR=8,9;BYMINUTE=30
FREQ=YEARLY
FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
FREQ=YEARLY;BYDAY=1SU;BYMONTH=4
FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
FREQ=YEARLY;BYDAY=1SU;BYMONTH=4;UNTIL=19980404T070000Z
FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
FREQ=YEARLY;BYDAY=1SU;BYMONTH=4;UNTIL=19980404T070000Z
FREQ=YEARLY;BYDAY=-1SU;BYMONTH=4
FREQ=DAILY;COUNT=10
FREQ=DAILY;UNTIL=19971224T000000Z
FREQ=DAILY;INTERVAL=2
FREQ=DAILY;INTERVAL=10;COUNT=5
FREQ=YEARLY;UNTIL=20000131T090000Z;BYMONTH=1;BYDAY=SU,MO,TU,WE,TH,FR,SA
FREQ=DAILY;UNTIL=20000131T090000Z;BYMONTH=1
FREQ=WEEKLY;COUNT=10
FREQ=WEEKLY;UNTIL=19971224T000000Z
FREQ=WEEKLY;INTERVAL=2;WKST=SU
FREQ=WEEKLY;UNTIL=19971007T000000Z;WKST=SU;BYDAY=TU,TH
FREQ=WEEKLY;COUNT=10;WKST=SU;BYDAY=TU,TH
FREQ=WEEKLY;INTERVAL=2;UNTIL=19971224T000000Z;WKST=SU;BYDAY=MO,WE,FR
FREQ=WEEKLY;INTERVAL=2;COUNT=8;WKST=SU;BYDAY=TU,TH
FREQ=MONTHLY;COUNT=10;BYDAY=1FR
FREQ=MONTHLY;UNTIL=19971224T000000Z;BYDAY=1FR
FREQ=MONTHLY;INTERVAL=2;COUNT=10;BYDAY=1SU,-1SU
FREQ=MONTHLY;COUNT=6;BYDAY=-2MO
FREQ=MONTHLY;BYMONTHDAY=-3
FREQ=MONTHLY;COUNT=10;BYMONTHDAY=2,15
FREQ=MONTHLY;COUNT=10;BYMONTHDAY=1,-1
FREQ=MONTHLY;INTERVAL=18;COUNT=10;BYMONTHDAY=10,11,12,13,14,15
FREQ=MONTHLY;INTERVAL=2;BYDAY=TU
FREQ=YEARLY;COUNT=10;BYMONTH=6,7
FREQ=YEARLY;INTERVAL=2;COUNT=10;BYMONTH=1,2,3
FREQ=YEARLY;INTERVAL=3;COUNT=10;BYYEARDAY=1,100,200
FREQ=YEARLY;BYDAY=20MO
FREQ=YEARLY;BYWEEKNO=20;BYDAY=MO
FREQ=YEARLY;BYMONTH=3;BYDAY=TH
FREQ=YEARLY;BYDAY=TH;BYMONTH=6,7,8
FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13
FREQ=MONTHLY;BYDAY=SA;BYMONTHDAY=7,8,9,10,11,12,13
FREQ=YEARLY;INTERVAL=4;BYMONTH=11;BYDAY=TU;BYMONTHDAY=2,3,4,5,6,7,8
FREQ=MONTHLY;COUNT=3;BYDAY=TU,WE,TH;BYSETPOS=3
FREQ=MONTHLY;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-2
FREQ=HOURLY;INTERVAL=3;UNTIL=19970902T170000Z
FREQ=MINUTELY;INTERVAL=15;COUNT=6
FREQ=MINUTELY;INTERVAL=90;COUNT=4
FREQ=DAILY;BYHOUR=9,10,11,12,13,14,15,16;BYMINUTE=0,20,40
FREQ=MINUTELY;INTERVAL=20;BYHOUR=9,10,11,12,13,14,15,16
FREQ=WEEKLY;INTERVAL=2;COUNT=4;BYDAY=TU,SU;WKST=MO
FREQ=WEEKLY;INTERVAL=2;COUNT=4;BYDAY=TU,SU;WKST=SU'
```
