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
    qtipStyle: '='
    qtip: '@'
    qtipTitle: '@'
    qtipContent: '@'
    qtipSelector: '@'
    qtipTemplate: '@'
    qtipEvent: '@'
    qtipEventOut: '@'
    qtipMy: '@'
    qtipAt: '@'
    object: '=qtipTemplateObject'
  link: (scope, el, attrs) ->
    string_to_bool = (str) -> !(String(str).toLowerCase() in ['false', '0', 'null'])

    my = scope.qtipMy || 'bottom center'
    at = scope.qtipAt || 'top center'
    qtipClass = attrs.qtipClass || 'qtip'
    adjustX = parseInt(scope.qtipAdjustX) || 0
    adjustY = parseInt(scope.qtipAdjustY) || 0
    content = scope.qtipContent || scope.qtip
    event = scope.qtipEvent || 'mouseover'
    eventOut = scope.qtipEventOut || 'mouseout'
    fixed = if scope.qtipFixed isnt null then string_to_bool scope.qtipFixed else yes
    delay = scope.qtipDelay || 100
    style =
      classes: qtipClass
      tip: scope.qtipStyle ? {}

    if scope.qtipEvent is 'false'
      event = false
    if scope.qtipEventOut is 'false'
      eventOut = false

    scope.closeQtip = (e) ->
      e?.preventDefault?()
      $('.qtip:visible').qtip 'hide'
      `void 0`

    generateQtip = (content) ->
      options =
        content: content
        position:
          my: my
          at: at
          target: el
          adjust:
            x: adjustX
            y: adjustY
        show:
          event: event
        hide:
          fixed: fixed
          delay: delay
          event: eventOut
        style: style

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
              $compile(html.data)(scope)
          , 1

    else if attrs.qtipTitle
      generateQtip title: scope.qtipTitle, text: scope.qtip

    else
      generateQtip text: ->
        $timeout ->
          scope.$apply ->
            $compile("<div>#{content}</div>")(scope)
        , 1

    `void 0`
]
