deleteTimeSegment
=================
This is an update to the original ERPLAB function DELBIGSEG. This adds a time buffer for the event-codes surround the to-be-deleted EEG data-segment. Also, adds a feature to ignore event codes.

This includes and uses a fixed version of ERPLAB's JOINCLOSESEGMENTS due to the current bug in automatically deleting the last rejection time-window.

