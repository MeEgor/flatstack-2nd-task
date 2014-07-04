angular
  .module 'userService', []
  .factory 'User', ($location, $http, Session)->

    service =
      show: (id)->
        $http
          .get "/users/#{id}.json"


      register: (email, password, confirm_password)->
        $http
          .post '/users.json',
            user:
              email: email
              password: password
              password_confirmation: confirm_password

      update: (user)->
        $http
          .put "/users/#{user.id}.json", user
          .then (resp)->
            Session.currentUser = null
            resp


      send_confirmation_email: (id)->
        $http
          .post "/users/#{id}/send_confirmation_email.json"

      verify_email: (token)->
        $http
          .post "/users/confirm_email/#{ token }.json"

      change_password: (user)->
        $http
          .post "/users/#{user.id}/change_password.json", user: user
          .then (resp)->
            Session.currentUser = null
            resp

      create_password: (user)->
        $http
          .post "/users/#{user.id}/create_password.json", user: user
          .then (resp)->
            Session.currentUser = null
            resp




