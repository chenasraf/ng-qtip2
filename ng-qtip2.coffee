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
    qtipDefaults: '=?'
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
      base =
        position:
          my: 'bottom center'
          at: 'top center'
          adjust:
            x: 0
            y: 0
        show:
          effect: yes
          event: 'mouseover'
        hide:
          effect: yes
          fixed: yes
          delay: 100
          event: 'mouseout'
        style:
          classes: 'qtip'
          modal: {}
          tip: {}
      options = angular.merge {}, base, scope.qtipDefaults || {}

      options.position.my = scope.qtipMy if scope.qtipMy?
      options.position.at = scope.qtipAt if scope.qtipAt?
      options.position.target = ($ scope.qtipTarget) if scope.qtipTarget?
      options.position.adjust.x = parseInt(scope.qtipAdjustX) if scope.qtipAdjustX?
      options.position.adjust.y = parseInt(scope.qtipAdjustY) if scope.qtipAdjustY?

      options.show.effect = scope.qtipShowEffect if scope.qtipShowEffect?
      options.show.event = scope.qtipEvent if scope.qtipEvent?
      options.show = scope.qtipShow if scope.qtipShow?

      options.hide.effect = scope.qtipHideEffect if scope.qtipHideEffect?
      options.hide.fixed = str2bool scope.qtipFixed if scope.qtipFixed?
      options.hide.event = scope.qtipEventOut if scope.qtipEventOut?
      options.hide = scope.qtipHide if scope.qtipHide?

      options.style.classes = scope.qtipClass if scope.qtipClass?
      options.style.modal = scope.qtipModalStyle if scope.qtipModalStyle?
      options.style.tip = scope.qtipTipStyle if scope.qtipTipStyle?

      options = angular.merge {}, options, scope.qtipOptions if scope.qtipOptions?
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
