NgQtip2 = ($timeout, $compile, $http, $templateCache) ->
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
    object: '=qtipTemplateObject'

  link: (scope, el, attrs) ->
    str2bool = (str) -> String(str).toLowerCase() not in ['false', '0', 'null', '']

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

    generateQtip = (content) ->
      options =
        position:
          my: scope.qtipMy ? 'bottom center'
          at: scope.qtipAt ? 'top center'
          target: if scope.qtipTarget? then ($ scope.qtipTarget) else el
          adjust:
            x: if scope.qtipAdjustX? then parseInt(scope.qtipAdjustX) else 0
            y: if scope.qtipAdjustY? then parseInt(scope.qtipAdjustY) else 0
        show:
          effect: scope.qtipShowEffect ? yes
          event: scope.qtipEvent ? 'mouseover'
        hide:
          effect: scope.qtipHideEffect ? yes
          fixed: if scope.qtipFixed then str2bool scope.qtipFixed else yes
          delay: scope.qtipDelay ? 100
          event: scope.qtipEventOut ? 'mouseout'
        style:
          classes: scope.qtipClass ? 'qtip'
          modal: scope.qtipModalStyle ? {}
          tip: scope.qtipTipStyle ? {}

      options.hide = scope.qtipHide if scope.qtipHide?
      options.show = scope.qtipShow if scope.qtipShow?
      options = angular.extend {}, options, scope.qtipOptions if scope.qtipOptions?
      options.content = if content? then content else text: scope.qtipContent ? scope.qtip

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

NgQtip2.$inject = ['$timeout', '$compile', '$http', '$templateCache']
angular.module('ngQtip2', []).directive 'qtip', NgQtip2
