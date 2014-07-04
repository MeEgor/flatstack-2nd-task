angular
  .module 'MyCalendar'
  .controller 'SingleUserCtrl', [
    '$scope', 'growl', '$location', 'User', 'Session', '$stateParams',
    (scope, growl, location, User, Session, stateParams)->
      if stateParams.verify_email_token
        User
          .verify_email stateParams.verify_email_token
          .then (resp)->
            if resp && resp.data.success
              growl.addSuccessMessage 'E-mail подтвержден'
              scope.set_current_user resp.data.user
            else
              growl.addErrorMessage "E-mail не подтвержден"
              angular.forEach resp.data.errors.email, (message)->
                growl.addErrorMessage message

          .then ()->
            location.$$search = {}
            location.path '/profile'

      scope.update_errors = {}

      scope.has_error = (field)->
        scope.update_errors.hasOwnProperty field

      scope.mouseover = (e)->
        e.currentTarget.innerHTML = "Подтвердить"

      scope.mouseleave = (e)->
        e.currentTarget.innerHTML = "Не подтвержден"

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
              scope.update_errors = resp.data.errors
              growl.addErrorMessage 'Обновление не удалось.'
          , (resp)->
              growl.addErrorMessage 'Сервер временно не доступен. Попробуйте позже.'

      scope.send_confirmation_email = ()->
        growl.addInfoMessage "Отправка письма с сыллкой для подтверждения e-mail"
        User.send_confirmation_email scope.current_user.id
        .then (resp)->
          if resp && resp.data.success
            growl.addSuccessMessage "Письмо отправлено!"
          else
            growl.addErrorMessage "Письмо не было отправлено."
        , (resp)->
            growl.addErrorMessage 'Сервер временно не доступен. Попробуйте позже.'

      scope.change_password = ()->
        User
          .change_password scope.current_user
          .then (resp)->
            if resp && resp.data.success
              scope.set_current_user resp.data.user
              scope.update_errors = {}
              location.path '/profile'
              growl.addSuccessMessage "Пароль успешно изменен."
            else
              scope.update_errors = resp.data.errors
              growl.addErrorMessage 'Обновление не удалось.'
          , (resp) ->
              growl.addErrorMessage 'Сервер временно не доступен. Попробуйте позже.'

  ]
