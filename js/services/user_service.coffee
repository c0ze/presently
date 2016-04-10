app.factory 'UserService', ->
  defaults =
    location: 'autoip'
    tempDisplay:
      degrees: 'celsius'

  @save = ->
    sessionStorage.presently = angular.toJson(@user)

  @restore = ->
    @user = angular.fromJson(sessionStorage.presently) or defaults
    @user

  @restore()

  @
