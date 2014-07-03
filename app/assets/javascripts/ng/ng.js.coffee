app = angular.module 'MyCalendar', [
  'ngRoute', 'sessionService', 'userService', 'angular-growl'
]

app
  .config ['$httpProvider', ($httpProvider)->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    interceptor = ['$location', '$rootScope', '$q', ($location, $rootScope, $q)->
      success = (resp)->
        resp

      error = (resp)->
        if resp.status == 401
          $rootScope.$broadcast 'event:unauthorized'
          $location.path '/sign_in'
          resp

      return (promise)->
        promise.then success, error
    ]
    $httpProvider.responseInterceptors.push interceptor
  ]

  .config ['$routeProvider', ($routeProvider)->
    $routeProvider
      .when '/sign_up',
        templateUrl: '/templates/users/sign_up'
        controller: 'NewUserCtrl'

      .when '/sign_in',
        templateUrl: 'templates/users/sign_in'
        controller: 'SessionCtrl'

      .when '/profile',
        templateUrl: 'templates/users/profile'
        controller: 'SingleUserCtrl'

      .when '/profile/edit/main',
        templateUrl: 'templates/users/edit-profile-main'
        controller: 'UserCtrl'

      .when '/profile/edit/password',
        templateUrl: 'templates/users/edit-profile-password'
        controller: 'UserCtrl'

      .otherwise { redirectTo: '/' }
  ]

  .config ['growlProvider', (growlProvider)->
    growlProvider.globalTimeToLive 2000
  ]
