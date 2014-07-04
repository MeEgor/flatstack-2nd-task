angular
  .module 'MyCalendar'
  .controller 'MonthCtrl', [
    '$scope', 'Session', 'growl', '$location', '$stateParams', 'Event',
    (scope, Session, growl, location, stateParams, Event)->

      base_date = moment "#{stateParams.year}-#{stateParams.month}-01"
        .lang 'ru'

      next_month = moment "#{stateParams.year}-#{stateParams.month}-01"
        .add 'months', 1
        .lang 'ru'

      prev_month = moment "#{stateParams.year}-#{stateParams.month}-01"
        .subtract 'months', 1
        .lang 'ru'

      scope.date = base_date.format "MMMM YYYY г."

      scope.days = []

      scope.next_month =
        name: next_month.format 'MMMM'
        link: "/#/#{next_month.format('YYYY/MM')}"

      scope.prev_month =
        name: prev_month.format 'MMMM'
        link: "/#/#{prev_month.format('YYYY/MM')}"

      scope.day_name = (day)->
        if day
          name = moment "#{stateParams.year}-#{stateParams.month}-#{day}"
            .lang 'ru'
            .format('dddd')
          name.charAt(0).toUpperCase() + name.slice(1)

      scope.humanize_events_count = (count)->
        if count
          "Событий: #{ count }"

      scope.link_to_day = (day)->
        if day
          date = moment "#{stateParams.year}-#{stateParams.month}-#{day}"
          "/#/#{date.format('YYYY/MM/DD')}"

      load_events = ()->
        Event
          .at_month base_date.format "YYYY-MM-DD"
          .then (resp)->
            scope.days = resp.data.days

      load_events()


  ]
