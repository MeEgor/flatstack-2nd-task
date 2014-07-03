angular
  .module 'userService', []
  .factory 'User', ($location, $http)->
    redirect = (url)->
      url = url || '/'
      $location.path url

    service =
      show: (id)->
        console.log id

      register: (email, password, confirm_password)->
        $http
          .post '/users',
            user:
              email: email
              password: password
              password_confirmation: confirm_password

      update: (user)->
        $http
          .put "/users/#{user.id}", user
          .then (resp)->
            if resp.data.success
              resp




