# главный контроллер
angular
  .module 'MyCalendar'
  .controller 'MainCtrl', ['$scope', 'Session', 'growl', '$location', '$stateParams', '$state',
  (scope, Session, growl, location, stateParams, state)->
    scope.current_user = null

    scope.link_to_calendar = "/#/#{moment().format('YYYY/MM')}"

    scope.set_current_user = (user)->
      scope.current_user = user

    scope.isUrl = (url)->
      location.path() == url

    scope.urlContains = (url)->
      location.path().indexOf(url) > -1

    Session
      .requestCurrentUser()
      .then (resp)->
        if resp
          scope.current_user = resp

  ]
