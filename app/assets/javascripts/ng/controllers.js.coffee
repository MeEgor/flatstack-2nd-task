angular
  # TODO разнести контроллеры по файлам

  .module('MyCalendar.controllers', [])
  # Контроллер пользователей
  .controller 'UserCtrl', ['$scope', 'growl', '$location', 'User', 'Session', (scope, growl, location, User, Session)->
    console.log 'UsersCtrl -> start'

    scope.update = ()->
      User
        .update scope.current_user
        .then (resp)->
          if resp && resp.data.success
            scope.set_current_user resp.data.user
            if scope.current_user.name
              growl.addSuccessMessage "С обновлением вас, #{ scope.current_user.name }!"
            else
              growl.addSuccessMessage "Обновление прошло удачно."
            location.path '/profile'
          else
            growl.addErrorMessage 'Обновление не удалось.'
        , (resp)->
            growl.addErrorMessage 'Сервер временно не доступен. Попробуйте позже.'

  ]





