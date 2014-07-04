app = angular.module 'MyCalendar', [
  'sessionService', 'userService', 'eventService', 'angular-growl', 'ui.router'
]

app
  .config ['$httpProvider', ($httpProvider)->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');

    interceptor = ['$location', '$rootScope', '$q', 'growl', ($location, $rootScope, $q)->
      success = (resp)->
        resp

      error = (resp)->
        if resp.status == 401
          $rootScope.$broadcast 'event:unauthorized'
          $location.path '/sign_in'
          resp

        if resp.status == 403
          $rootScope.$broadcast 'event:accessdenied'
          $location.path '/'
          resp

      return (promise)->
        promise.then success, error
    ]
    $httpProvider.responseInterceptors.push interceptor
  ]

  .config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider)->
    $urlRouterProvider.otherwise("/")
    $stateProvider
      .state 'index',
        url:  '/'
        templateUrl: 'templates/index'
        controller: 'IndexCtrl'

      .state 'sign_up',
        url: '/sign_up'
        templateUrl: '/templates/users/sign_up'
        controller: 'NewUserCtrl'

      .state 'sign_in',
        url: '/sign_in'
        templateUrl: 'templates/users/sign_in'
        controller: 'SessionCtrl'

      .state 'user',
        url: '/user/:id?verify_email_token'
        templateUrl: 'templates/users/show'
        controller: 'SingleUserCtrl'

      .state 'user_edit_main',
        url: '/user/:id/edit'
        templateUrl: 'templates/users/edit-main'
        controller: 'SingleUserCtrl'

      .state 'user_edit_password',
        url: '/user/:id/password'
        templateUrl: 'templates/users/edit-password'
        controller: 'SingleUserCtrl'

      .state 'day',
        url: '/{year:[0-9]{4}}/{month:0[1-9]|1[0-2]}/{day:0[1-9]|[12][0-9]|3[01]}'
        templateUrl: 'templates/events/day'
        controller: 'DayCtrl'

      .state 'month',
        url:  '/{year:[0-9]{4}}/{month:0[1-9]|1[0-2]}'
        templateUrl: 'templates/events/month'
        controller: 'MonthCtrl'

      .state 'edit_event',
        url: '/events/:id/edit'
        templateUrl: 'templates/events/edit'
        controller: 'SingleEventCtrl'


  ]

  .config ['growlProvider', (growlProvider)->
    growlProvider.globalTimeToLive 2000
  ]

  .run ($rootScope, $state)->
    $rootScope.$on '$stateChangeSuccess', (ev, to, toParams, from, fromParams) ->
      $state.previous = from
      $state.previousParams = fromParams

    $rootScope.$state = $state
