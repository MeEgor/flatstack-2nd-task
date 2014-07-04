# главный контроллер
angular
  .module 'MyCalendar'
  .controller 'MainCtrl', ['$scope', 'Session', 'growl', '$location', '$stateParams', '$state', '$rootScope',
  (scope, Session, growl, location, stateParams, state, rootScope)->
    scope.current_user = null

    scope.link_to_calendar = "/#/#{moment().format('YYYY/MM')}"

    scope.set_current_user = (user)->
      scope.current_user = user

    scope.isUrl = (url)->
      location.path() == url

    scope.urlContains = (url)->
      location.path().indexOf(url) > -1



    scope.$on 'event:unauthorized', ()->
      growl.addErrorMessage 'Войдите, чтобы совершить действие'

    scope.$on 'event:accessdenied', ()->
      growl.addErrorMessage 'Доступ запрещен'

    rootScope.$on '$stateChangeSuccess', ()->
      Session
        .requestCurrentUser()
        .then (user)->
          scope.set_current_user user
  ]
