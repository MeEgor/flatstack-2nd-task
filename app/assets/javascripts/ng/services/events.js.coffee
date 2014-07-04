angular
  .module 'eventService', []
  .factory 'Event', ($location, $http)->
    service =
      show: (id)->
        $http
          .get "/events/#{id}"

      at_day: (date)->
        $http
          .get "/events/day/#{date}.json"

      at_month: (date)->
        $http
          .get "/events/month/#{date}.json"

      create: (e)->
        $http
          .post '/events', e

      update: (e)->
        $http
          .put "/events/#{e.id}", e

      destroy: (id)->
        $http
          .delete "events/#{id}"

      periods: [
        {code: 0, name:'Одиночное событие'}
        {code: 1, name:'Каждый день'}
        {code: 2, name:'Каждую неделю'}
        {code: 3, name:'Каждый месяц'}
        {code: 4, name:'Каждый год'}
      ]





