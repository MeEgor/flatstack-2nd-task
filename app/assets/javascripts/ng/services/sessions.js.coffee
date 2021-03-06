angular
  .module 'sessionService', []
  .factory 'Session', ($location, $http, $q)->

    redirect = (url)->
      url = url || '/'
      $location.path url

    service =
      login: (email, password)->
        $http
          .post '/sessions.json',
            session:
              email: email
              password: password
          .then (resp)->
            service.currentUser = resp.data.current_user
            if service.isSignedIn()
              redirect()

      logout: (redirectTo)->
        $http
          .delete '/sign_out'
          .then (resp)->
            $http.defaults.headers.common['X-CSRF-Token'] = resp.data.csrfToken
            service.currentUser = null
            redirect redirectTo

      requestCurrentUser: ()->
        if service.isSignedIn()
          $q.when(service.currentUser)
        else
          $http
            .get '/current_user.json'
            .then (resp)->
              service.currentUser = resp.data.current_user
              service.currentUser

      currentUser: null

      isSignedIn: ()->
        service.currentUser != null

