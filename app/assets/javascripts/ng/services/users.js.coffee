angular
  .module 'userService', []
  .factory 'User', ($location, $http)->
    redirect = (url)->
      url = url || '/'
      $location.path url

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

      send_confirmation_email: (id)->
        $http
          .post "/users/#{id}/send_confirmation_email.json"

      verify_email: (token)->
        $http
          .post "/users/confirm_email/#{ token }.json"

      change_password: (user)->
        $http
          .post "/users/#{user.id}/change_password.json", user: user




