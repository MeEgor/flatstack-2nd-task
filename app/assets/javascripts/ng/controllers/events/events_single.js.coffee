angular
  .module 'MyCalendar'
  .controller 'SingleEventCtrl', [
    '$scope', 'Event', 'growl', '$location', '$stateParams', '$state',
    (scope, Event, growl, location, stateParams, state)->
      scope.event = {}
      scope.update_errors = {}
      scope.periods = Event.periods

      scope.has_error = (field)->
        scope.update_errors.hasOwnProperty field

      scope.update = ()->
        Event
          .update scope.event
          .then (resp)->
            if resp && resp.data.success
              growl.addSuccessMessage "Событие обновлено"
              href = state.href(state.previous, state.previousParams)
              if href
                location.path href.substring(1)
            else
              scope.update_errors = resp.data.errors
              growl.addErrorMessage "Ошибка при обновлении события"



      Event
        .show stateParams.id
        .then (resp)->
          if resp && resp.data.success
            scope.event = resp.data.event
          else
            growl.addErrorMessage 'Событие не загружено'


    ]
