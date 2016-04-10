app = angular.module 'myApp', [ 'ngRoute' ]

app.provider 'Weather', ->
  apiKey = '$API_KEY'

  @getUrl = (type, ext) ->
    'http://api.wunderground.com/api/' + @apiKey + '/' + type + '/q/' + ext + '.json'

  @setApiKey = (key) ->
    if key
      @apiKey = key

  @$get = ($q, $http) ->
    self = this
    {
      getWeatherForecast: (city) ->
        d = $q.defer()
        $http(
          method: 'GET'
          url: self.getUrl('forecast', city)
          cache: true).success((data) ->
          d.resolve data.forecast.simpleforecast
          return
        ).error (err) ->
          d.reject err
          return
        d.promise
      getCityDetails: (query) ->
        d = $q.defer()
        $http(
          method: 'GET'
          url: 'http://autocomplete.wunderground.com/aq?query=' + query).success((data) ->
          d.resolve data.RESULTS
          return
        ).error (err) ->
          d.reject err
          return
        d.promise

    }

  @
