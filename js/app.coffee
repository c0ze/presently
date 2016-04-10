angular.module('myApp', [ 'ngRoute' ]).provider('Weather', ->
  apiKey = '$API_KEY'

  @getUrl = (type, ext) ->
    'http://api.wunderground.com/api/' + @apiKey + '/' + type + '/q/' + ext + '.json'

  @setApiKey = (key) ->
    if key
      @apiKey = key
    return

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

  return
).factory('UserService', ->
  defaults = location: 'autoip'
  service = 
    user: {}
    save: ->
      sessionStorage.presently = angular.toJson(service.user)
      return
    restore: ->
      service.user = angular.fromJson(sessionStorage.presently) or defaults
      service.user
  service.restore()
  service
).config((WeatherProvider) ->
  WeatherProvider.setApiKey '$API_KEY'
  return
).config([
  '$routeProvider'
  ($routeProvider) ->
    $routeProvider.when('/',
      templateUrl: 'templates/home.html'
      controller: 'MainCtrl').when('/settings',
      templateUrl: 'templates/settings.html'
      controller: 'SettingsCtrl').otherwise redirectTo: '/'
    return
]).directive('autoFill', ($timeout, Weather) ->
  {
    restrict: 'EA'
    scope:
      autoFill: '&'
      ngModel: '='
      timezone: '='
    compile: (tEle, tAttrs) ->
      tplEl = angular.element('<div class="typeahead">' + '<input type="text" autocomplete="off" />' + '<ul id="autolist" ng-show="reslist">' + '<li ng-repeat="res in reslist" ' + '>{{res.name}}</li>' + '</ul>' + '</div>')
      input = tplEl.find('input')
      input.attr 'type', tAttrs.type
      input.attr 'ng-model', tAttrs.ngModel
      input.attr 'timezone', tAttrs.timezone
      tEle.replaceWith tplEl
      (scope, ele, attrs, ctrl) ->
        minKeyCount = attrs.minKeyCount or 3
        timer = undefined
        ele.bind 'keyup', (e) ->
          val = ele.val()
          if val.length < minKeyCount
            if timer
              $timeout.cancel timer
            scope.reslist = null
            return
          else
            if timer
              $timeout.cancel timer
            timer = $timeout((->
              scope.autoFill()(val).then (data) ->
                if data and data.length > 0
                  scope.reslist = data
                  scope.ngModel = data[0].zmw
                  scope.timezone = data[0].tz
                return
              return
            ), 300)
          return
        # Hide the reslist on blur
        input.bind 'blur', (e) ->
          scope.reslist = null
          scope.$digest()
          return
        return

  }
).controller('MainCtrl', ($scope, $timeout, Weather, UserService) ->
  $scope.date = {}

  updateTime = ->
    $scope.date.tz = new Date((new Date).toLocaleString('en-US', timeZone: $scope.user.timezone))
    $timeout updateTime, 1000
    return

  $scope.weather = {}
  $scope.user = UserService.user
  Weather.getWeatherForecast($scope.user.location).then (data) ->
    $scope.weather.forecast = data
    return
  updateTime()
  return
).controller 'SettingsCtrl', ($scope, $location, Weather, UserService) ->
  $scope.user = UserService.user

  $scope.save = ->
    UserService.save()
    $location.path '/'
    return

  $scope.fetchCities = Weather.getCityDetails
  return

# ---
# generated by js2coffee 2.2.0
