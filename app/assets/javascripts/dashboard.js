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
      response.room
    );
  }
  
  MeetingRooms.EventDashboard = EventDashboard;
}());
