(function() {
  "use strict";
  window.MeetingRooms = window.MeetingRooms || {};

  function EventDashboard(options) {
    this.$el = options.el;
    this.dataSource = options.dataSource;
    this.template = options.template;
    this.delay = options.delay;

    this.loadEvents();
  }

  EventDashboard.prototype.loadEvents = function loadEvents(){
    $.getJSON(
      this.dataSource,
      $.proxy(this.renderEvents, this)
    );

    setTimeout( $.proxy(this.loadEvents, this), this.delay);
  }

  EventDashboard.prototype.renderEvents = function renderEvents(response){
    this.$el.mustache(
      this.template,
      this.buildContext(response.room)
    );
  }

  EventDashboard.prototype.buildContext = function buildContext(room) {
    return {
      schedule: $.map(
        room.schedule,
        $.proxy(this.formatEvent, this)
      )
    }
  }

  EventDashboard.prototype.formatEvent = function formatEvent(event) {
    return {
      title: event.title,
      start_at: this.formatTime(event.start_at),
      end_at: this.formatTime(event.end_at)
    }
  }

  EventDashboard.prototype.formatTime = function formatTime(timestamp){
    return moment(timestamp).format("h:mma");
  }

  MeetingRooms.EventDashboard = EventDashboard;
}());
