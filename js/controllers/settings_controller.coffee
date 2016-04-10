app.controller 'SettingsCtrl', ($scope, $location, Weather, UserService) ->
  $scope.user = UserService.user
  $scope.tempChoices = [
      degrees: 'celsius'
    ,
      degrees: 'fahrenheit'
    ]

  $scope.save = ->
    UserService.save()
    $location.path '/'

  $scope.fetchCities = Weather.getCityDetails
