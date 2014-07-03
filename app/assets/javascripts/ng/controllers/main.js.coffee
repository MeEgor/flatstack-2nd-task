# главный контроллер
angular
  .module 'MyCalendar'
  .controller 'MainCtrl', ['$scope', 'Session', 'growl', '$location', (scope, Session, growl, location)->
    console.log 'MainCtrl -> start'

    scope.current_user = null

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
