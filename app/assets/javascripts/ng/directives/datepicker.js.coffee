angular.module('MyCalendar')
  .directive 'datepicker', () ->

    link: (scope, element, attrs) ->
      $(element)
        .datepicker {
          format: 'yyyy-mm-dd'
        }
        .on 'changeDate', (e)->
          scope.$apply ()->
            scope.event.started_at = $(e.currentTarget).val()
