angular.module('ngQtip2', [])
.directive 'qtip', ['$timeout', '$compile', '$http', '$templateCache', ($timeout, $compile, $http, $templateCache)->
  restrict: 'A'
  scope:
    qtipVisible: '='
    qtipDisable: '='
    qtipFixed: '='
    qtipDelay: '='
    qtipAdjustX: '='
    qtipAdjustY: '='
    qtipModalStyle: '='
    qtipTipStyle: '='
    qtip: '@'
    qtipTitle: '@'
    qtipTarget: '@'
    qtipContent: '@'
    qtipSelector: '@'
    qtipTemplate: '@'
    qtipEvent: '@'
    qtipEventOut: '@'
    qtipHide: '='
    qtipShow: '='
    qtipClass: '@'
    qtipMy: '@'
    qtipAt: '@'
    qtipOptions: '='
    object: '=qtipTemplateObject'
  link: (scope, el, attrs) ->
    str2bool = (str) -> String(str).toLowerCase() not in ['false', '0', 'null', '']

    if scope.qtipEvent is 'false'
      event = false
    if scope.qtipEventOut is 'false'
      eventOut = false

    scope.closeQtip = (e, id = el.data('hasqtip')) ->
      e?.preventDefault?()
      $("#qtip-#{id}").qtip 'hide'
      `void 0`

    generateQtip = (content) ->
      options =
        position:
          my: scope.qtipMy ? 'bottom center'
          at: scope.qtipAt ? 'top center'
          target: scope.qtipTarget ? el
          adjust:
            x: if scope.qtipAdjustX? then parseInt(scope.qtipAdjustX) else 0
            y: if scope.qtipAdjustY? then parseInt(scope.qtipAdjustY) else 0
        show:
          event: if str2bool scope.qtipEvent then scope.qtipEvent else 'mouseover'
        hide:
          fixed: if scope.qtipFixed isnt null then str2bool scope.qtipFixed else yes
          delay: scope.qtipDelay ? 100
          event: if str2bool scope.qtipEventOut then scope.qtipEventOut else 'mouseout'
        style:
          classes: if str2bool scope.qtipClass then scope.qtipClass else 'qtip'
          modal: scope.qtipModalStyle ? {}
          tip: scope.qtipTipStyle ? {}

      options.hide = scope.qtipHide if scope.qtipHide?
      options.show = scope.qtipShow if scope.qtipShow?
      options = angular.extend {}, options, scope.qtipOptions if scope.qtipOptions?
      options.content = if content? then content else text: scope.qtipContent ? scope.qtip

      $(el).qtip options

      if attrs.qtipVisible
        scope.$watch 'qtipVisible', (new_val) -> $(el).qtip 'toggle', new_val

      if attrs.qtipDisable
        scope.$watch 'qtipDisable', (new_val) -> $(el).qtip 'disable', new_val

      if attrs.qtipTitle
        scope.$watch 'qtipTitle', (new_val) -> $(el).qtip 'option', 'content.title', new_val

      scope.$watch 'qtip', (new_val, old_val) -> $(el).qtip 'option', 'content.text', new_val if new_val isnt old_val

    if attrs.qtipSelector
      $timeout (-> generateQtip $(scope.qtipSelector).html()), 1

    else if attrs.qtipTemplate
      $http.get scope.qtipTemplate, cache: $templateCache
      .then (html) ->
        generateQtip text: ->
          $timeout ->
            scope.$apply ->
              text = $compile(html.data)(scope)
              return text
          , 1

    else if attrs.qtipTitle
      generateQtip title: scope.qtipTitle, text: scope.qtip

    else
      content = scope.qtip ? scope.qtipContent
      generateQtip text: ->
        $timeout ->
          scope.$apply ->
            $compile("<div>#{content}</div>")(scope)
        , 1

    `void 0`
]
