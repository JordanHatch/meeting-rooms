# Meeting Rooms [![Build Status](https://travis-ci.org/JordanHatch/meeting-rooms.png?branch=master)](https://travis-ci.org/JordanHatch/meeting-rooms)

This is a work-in progress attempt at rebuilding the service behind the meeting
room dashboards at GDS.

The major changes here are:

- Bringing everything into a single app, making the service simpler to
  understand and operate, which in turn will make it easier for others to use.
- Instead of rendering an API response, building a cache of each event, so that
  it will be possible to add more data to each event outside of that stored in
  Google Calendar - for example, a flag to track whether a user has 'checked in'
  to their booked meeting room.
- A test suite, so that changes can be made more easily. The existing service
  evolved from a rough-and-ready prototype, making it difficult to diagnose
  issues.
- The ability to add and remove rooms through a web interface - so that we no
  longer manage the list of rooms using environment variables.
