angular
  .module 'MyCalendar'
  .controller 'SingleUserCtrl', [
    '$scope', 'growl', '$location', 'User', 'Session', '$stateParams', '$state',
    (scope, growl, location, User, Session, stateParams, state)->
      # подтверждение email
      # TODO вынести куда-нибудь отдельно.
      if stateParams.verify_email_token
        User
          .verify_email stateParams.verify_email_token
          .then (resp)->
            if resp && resp.data.success
              growl.addSuccessMessage 'E-mail подтвержден'
            else
              growl.addErrorMessage "E-mail не подтвержден"
              angular.forEach resp.data.errors.email, (message)->
                growl.addErrorMessage message

          .then ()->
            Session
              .requestCurrentUser()
              .then (user)->
                scope.set_current_user user
                state.transitionTo 'user', { id: user.id }

      scope.user = {}
      scope.update_errors = {}
      scope.has_error = (field)->
        scope.update_errors.hasOwnProperty field


      load_user = ()->
        User
          .show stateParams.id
          .then (resp)->
            scope.user = resp.data.user
            console.log 'user loaded'
          , (resp)->
              console.log 'user not loaded'

      scope.update = ()->
        User
          .update scope.user
          .then (resp)->
            if resp && resp.data.success
              Session
                .requestCurrentUser()
                .then (user)->
                  scope.set_current_user user
                  growl.addSuccessMessage "Обновление прошло удачно."
                  state.transitionTo 'user', { id: scope.user.id }
            else
              scope.update_errors = resp.data.errors
              growl.addErrorMessage 'Обновление не удалось.'

      scope.send_confirmation_email = ()->
        growl.addInfoMessage "Отправка письма с сыллкой для подтверждения e-mail"
        User.send_confirmation_email scope.user.id
        .then (resp)->
          if resp && resp.data.success
            growl.addSuccessMessage "Письмо отправлено!"
          else
            growl.addErrorMessage "Письмо не было отправлено."

      scope.change_password = ()->
        User
          .change_password scope.user
          .then (resp)->
            if resp && resp.data.success
              scope.update_errors = {}
              growl.addSuccessMessage "Пароль успешно изменен."
              state.transitionTo 'user', { id: scope.user.id }

            else
              scope.update_errors = resp.data.errors
              growl.addErrorMessage 'Обновление не удалось.'

      scope.create_password = ()->
        User
          .create_password scope.user
          .then (resp)->
            if resp && resp.data.success
              scope.update_errors = {}
              growl.addSuccessMessage "Пароль успешно создан."
              state.transitionTo 'user', { id: scope.user.id }

            else
              scope.update_errors = resp.data.errors
              growl.addErrorMessage 'Пароль не создан.'

      scope.remove_vk = ()->
        User
          .remove_vk scope.user.id
          .then (resp)->
            if resp && resp.data.success
              growl.addSuccessMessage "Учетная запись отвязана."
              state.transitionTo 'user', { id: scope.user.id }

            else
              growl.addErrorMessage "Учетная запись не отвязана."
              angular.forEach resp.data.errors.vk_uid, (msg)->
                growl.addErrorMessage msg
              state.transitionTo 'user', { id: scope.user.id }


      load_user()

  ]
