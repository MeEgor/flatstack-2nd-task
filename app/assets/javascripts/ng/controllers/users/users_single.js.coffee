angular
  .module 'MyCalendar'
  .controller 'SingleUserCtrl', ['$scope',  'growl', '$location', 'User', (scope, growl, location, User)->
      console.log 'NewUserCtrl -> start'
  ]
