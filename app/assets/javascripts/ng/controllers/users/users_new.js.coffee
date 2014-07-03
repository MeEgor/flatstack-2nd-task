angular
  .module 'MyCalendar'
  .controller 'NewUserCtrl', [
    '$scope',  'growl', '$location', 'User', 'Session',
    (scope, growl, location, User, Session)->

      scope.registration_errors = {}

      scope.has_error = (field)->
        scope.registration_errors.hasOwnProperty field

      Session
        .requestCurrentUser()
        .then (resp)->
          if resp
            location.path '/'
          else
            scope.user =
              email: null
              password: null
              password_confirmation: null

      scope.register = ()->
        User
          .register scope.user.email, scope.user.password, scope.user.password_confirmation
          .then (resp)->
            if resp.data.success
              Session
                .requestCurrentUser()
                .then (user)->
                  scope.set_current_user user
                  if scope.current_user.name
                    growl.addSuccessMessage "Добро пожаловать #{ scope.current_user.name }!"
                  else
                    growl.addSuccessMessage "Добро пожаловать."
                  location.path '/profile'

            else
              scope.registration_errors = resp.data.errors
              growl.addErrorMessage 'Ошибки при создании пользователя.'
  ]
