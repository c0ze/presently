app.controller 'MainCtrl', ($scope, $timeout, Weather, UserService) ->
  $scope.date = {}

  updateTime = ->
    $scope.date.tz = new Date((new Date).toLocaleString('en-US', timeZone: $scope.user.timezone))
    $timeout updateTime, 1000

  $scope.weather = {}
  $scope.user = UserService.user
  Weather.getWeatherForecast($scope.user.location).then (data) ->
    $scope.weather.forecast = data

  updateTime()
