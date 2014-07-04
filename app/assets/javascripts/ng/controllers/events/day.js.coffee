angular
  .module 'MyCalendar'
  .controller 'DayCtrl', [
    '$scope', 'Event', 'growl', '$location', '$stateParams',
    (scope, Event, growl, location, stateParams)->
      console.log 'DayCtrl -> start', Event.periods

      day = moment "#{stateParams.year}-#{stateParams.month}-#{stateParams.day}"
      day.lang 'ru'

      scope.date = day.format "DD MMMM YYYY г., dddd"

      scope.events = []

      scope.new_event =
        started_at: day.format "YYYY-MM-DD"
        name: null
        period: 0

      scope.creation_errors = []

      scope.has_error = (field)->
        scope.creation_errors.hasOwnProperty field

      scope.periods = Event.periods

      scope.remove = (id)->
        console.log "remove #{id}"

      load_events = ()->
        Event
          .at_day day.format "YYYY-MM-DD"
          .then (resp)->
            scope.events = resp.data.events

      scope.create_event = ()->
        scope.creation_errors = []
        Event
          .create scope.new_event
          .then (resp)->
            if resp && resp.data.success
              load_events()
              scope.new_event =
                started_at: day.format "YYYY-MM-DD"
                name: null
                period: 0
              growl.addSuccessMessage "Новое событие создано"
            else
              scope.creation_errors = resp.data.errors
              growl.addErrorMessage "Событие не создано"

      scope.delete_event = (id)->
        Event
          .destroy id
          .then (resp)->
            if resp && resp.data.success
              growl.addSuccessMessage 'Событие удалено.'
              load_events()
            else
              growl addErrorMessage 'Событие не удалено.'

      load_events()

  ]
