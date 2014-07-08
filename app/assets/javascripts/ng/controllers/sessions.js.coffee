# Контроллер сессии (вход выход)
angular
  .module 'MyCalendar'
  .controller 'SessionCtrl', [ '$scope', 'Session', 'growl', (scope, Session, growl)->



    scope.user =
      email: null
      password: null

    scope.login = ()->
      Session
        .login scope.user.email, scope.user.password
        .then (response)->
          if !response
            growl.addErrorMessage 'Логин / Пароль не верные'
          else
            Session
              .requestCurrentUser()
              .then (user)->
                scope.set_current_user Session.currentUser
                growl.addSuccessMessage "Здравствуйте #{scope.current_user.name}"

        , (response)->
            growl.addErrorMessage 'Сервер временно не доступен. Попробуйте позже.'

    scope.logout = ()->
      user = scope.current_user
      Session
        .logout '/sign_in'
        .then ()->
          scope.set_current_user null
          growl.addSuccessMessage "До свидания #{ user.name }"
  ]
