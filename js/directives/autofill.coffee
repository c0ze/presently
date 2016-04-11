app.directive 'autoFill', ($timeout, Weather) ->
  restrict: 'EA'
  scope:
    autoFill: '&'
    ngModel: '='
    timezone: '='
  templateUrl: '/templates/autofill.html'
  compile: (tEle, tAttrs) ->
    input = tEle.find('input')
    input.attr 'type', tAttrs.type
    input.attr 'ng-model', tAttrs.ngModel
    input.attr 'timezone', tAttrs.timezone
    (scope, ele, attrs, ctrl) ->
      minKeyCount = attrs.minKeyCount or 3
      timer = undefined
      ele.bind 'keyup', (e) ->
        val = ele.val()
        if val.length < minKeyCount
          if timer
            $timeout.cancel timer
          scope.reslist = null
        else
          if timer
            $timeout.cancel timer
          timer = $timeout((->
            scope.autoFill()(val).then (data) ->
              if data and data.length > 0
                scope.reslist = data
                scope.ngModel = data[0].name
                scope.timezone = data[0].tz
          ), 300)
      # Hide the reslist on blur
      input.bind 'blur', (e) ->
        scope.reslist = null
        scope.$digest()
