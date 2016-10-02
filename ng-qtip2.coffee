NgQtip2 = ($timeout, $compile, $http, $templateCache, qtipDefaults, $q) ->
  restrict: 'A'
  scope:
    qtipVisible: '=?'
    qtipDisable: '=?'
    qtipFixed: '=?'
    qtipDelay: '=?'
    qtipAdjustX: '@'
    qtipAdjustY: '@'
    qtipModalStyle: '=?'
    qtipTipStyle: '=?'
    qtipShowEffect: '=?'
    qtipHideEffect: '=?'
    qtipPersistent: '=?'
    qtip: '@'
    qtipTitle: '@'
    qtipTarget: '@'
    qtipContent: '@'
    qtipSelector: '@'
    qtipTemplate: '@'
    qtipEvent: '@'
    qtipEventOut: '@'
    qtipHide: '=?'
    qtipShow: '=?'
    qtipClass: '@'
    qtipMy: '@'
    qtipAt: '@'
    qtipOptions: '=?'
    qtipApi: '=?'
    object: '=qtipTemplateObject'

  link: (scope, el, attrs) ->
    scope.qtipOptions ?= {}

    str2bool = (str) -> String(str).toLowerCase() not in ['false', '0', 'null', '']

    scope.apiPromise = $q.defer()

    scope.getQtipId = ->
      el.data('hasqtip')

    scope.getQtipElement = (id = scope.getQtipId()) ->
      ($ "#qtip-#{id}")

    scope.closeQtip = (e, id = scope.getQtipId(), {rendered = yes} = {}) ->
      e?.preventDefault?()
      qtEl = ($ "#qtip-#{id}")
      qtEl.qtip 'hide'
      qtEl.qtip().rendered = scope.qtipPersistent ? rendered
      return

    removeEmpties = (obj, deep = true) ->
      for k, v of obj
        if v? and typeof v is 'object' and deep
          removeEmpties obj[k], deep
        else if not v?
          delete obj[k]

    scope.api = (e, id = scope.getQtipId()) ->
      qtEl = ($ "#qtip-#{id}")
      return qtEl.qtip "api"

    scope.isApiReady = -> !!scope.getQtipElement().qtip().rendered

    scope.qtipApi =
      isReady: scope.isApiReady
      api: scope.api
      apiPromise: scope.apiPromise.promise

    scope.resolveApiPromise = (event, api) ->
      scope.apiPromise.resolve(api)

    scope._before = (before, fn) -> ->
      before?(arguments...)
      fn?(arguments...)

    generateQtip = (content) ->
      attrOptions =
        position:
          my: scope.qtipMy
          at: scope.qtipAt
          target: if scope.qtipTarget? then ($ scope.qtipTarget)
          adjust:
            x: if scope.qtipAdjustX? then parseInt(scope.qtipAdjustX)
            y: if scope.qtipAdjustY? then parseInt(scope.qtipAdjustY)
        show:
          effect: scope.qtipShowEffect
          event: scope.qtipEvent
        hide:
          effect: scope.qtipHideEffect
          fixed: str2bool scope.qtipFixed
          event: scope.qtipEventOut
        style:
          classes: scope.qtipClass
          modal: scope.qtipModalStyle
          tip: scope.qtipTipStyle
        content: if content? then content else text: scope.qtipContent ? scope.qtip

      angular.merge attrOptions.hide, scope.qtipHide if scope.qtipHide?
      angular.merge attrOptions.show, scope.qtipShow if scope.qtipShow?
      removeEmpties options
      removeEmpties attrOptions
      removeEmpties scope.qtipOptions
      options = angular.merge {}, qtipDefaults, attrOptions, scope.qtipOptions

      if options.events?.render?
        options.events.render = scope._before(scope.resolveApiPromise, options.events.render)
      else
        options.events ?= {}
        options.events.render = scope.resolveApiPromise

      ($ el).qtip options

      if attrs.qtipVisible?
        scope.$watch 'qtipVisible', (newVal) ->
          ($ el).qtip 'toggle', newVal

      if attrs.qtipDisable?
        scope.$watch 'qtipDisable', (newVal) ->
          ($ el).qtip 'disable', newVal

      if scope.qtipTitle?
        scope.$watch 'qtipTitle', (newVal) ->
          ($ el).qtip 'option', 'content.title', newVal

      scope.$watch 'qtip', (newVal, oldVal) ->
        ($ el).qtip 'option', 'content.text', newVal if newVal isnt oldVal

    if attrs.qtipSelector
      $timeout ->
        generateQtip ($ scope.qtipSelector).html()

    else if scope.qtipTemplate?
      $http.get scope.qtipTemplate, cache: $templateCache
      .then (html) ->
        generateQtip text: ->
          $timeout ->
            scope.$apply ->
              text = $compile(html.data)(scope)
              return text

    else if scope.qtipTitle?
      generateQtip title: scope.qtipTitle, text: scope.qtip

    else
      content = scope.qtip ? scope.qtipContent
      generateQtip text: ->
        $timeout ->
          scope.$apply ->
            $compile("<div>#{content}</div>")(scope)

    return

NgQtip2.$inject = ['$timeout', '$compile', '$http', '$templateCache', 'qtipDefaults', '$q']

angular.module('ngQtip2', [])
  .directive 'qtip', NgQtip2
  .provider 'qtipDefaults', ->
    @defaults = {}

    @setDefaults = (defaults = {}) =>
      angular.merge @defaults, defaults

    @$get = => @defaults

    return
