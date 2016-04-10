app.config [ '$routeProvider', 'WeatherProvider'
  ($routeProvider, WeatherProvider) ->
    WeatherProvider.setApiKey '$API_KEY'

    $routeProvider
    .when('/',
      templateUrl: 'templates/home.html'
      controller: 'MainCtrl')
    .when('/settings',
      templateUrl: 'templates/settings.html'
      controller: 'SettingsCtrl')
    .otherwise redirectTo: '/'

]
