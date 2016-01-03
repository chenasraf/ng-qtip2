(function() {
  angular.module('ngQtip2', []).directive('qtip', [
    '$timeout', '$compile', '$http', '$templateCache', function($timeout, $compile, $http, $templateCache) {
      return {
        restrict: 'A',
        scope: {
          qtipVisible: '=',
          qtipDisable: '=',
          qtipFixed: '=',
          qtipDelay: '=',
          qtipAdjustX: '=',
          qtipAdjustY: '=',
          qtipStyle: '=',
          qtip: '@',
          qtipTitle: '@',
          qtipContent: '@',
          qtipSelector: '@',
          qtipTemplate: '@',
          qtipEvent: '@',
          qtipEventOut: '@',
          qtipMy: '@',
          qtipAt: '@',
          object: '=qtipTemplateObject'
        },
        link: function(scope, el, attrs) {
          var adjustX, adjustY, at, content, delay, event, eventOut, fixed, generateQtip, my, qtipClass, ref, string_to_bool, style;
          string_to_bool = function(str) {
            var ref;
            return !((ref = String(str).toLowerCase()) === 'false' || ref === '0' || ref === 'null');
          };
          my = scope.qtipMy || 'bottom center';
          at = scope.qtipAt || 'top center';
          qtipClass = attrs.qtipClass || 'qtip';
          adjustX = parseInt(scope.qtipAdjustX) || 0;
          adjustY = parseInt(scope.qtipAdjustY) || 0;
          content = scope.qtipContent || scope.qtip;
          event = scope.qtipEvent || 'mouseover';
          eventOut = scope.qtipEventOut || 'mouseout';
          fixed = scope.qtipFixed !== null ? string_to_bool(scope.qtipFixed) : true;
          delay = scope.qtipDelay || 100;
          style = {
            classes: qtipClass,
            tip: (ref = scope.qtipStyle) != null ? ref : {}
          };
          if (scope.qtipEvent === 'false') {
            event = false;
          }
          if (scope.qtipEventOut === 'false') {
            eventOut = false;
          }
          scope.closeQtip = function(e) {
            if (e != null) {
              if (typeof e.preventDefault === "function") {
                e.preventDefault();
              }
            }
            $('.qtip:visible').qtip('hide');
            return void 0;
          };
          generateQtip = function(content) {
            var options;
            options = {
              content: content,
              position: {
                my: my,
                at: at,
                target: el,
                adjust: {
                  x: adjustX,
                  y: adjustY
                }
              },
              show: {
                event: event
              },
              hide: {
                fixed: fixed,
                delay: delay,
                event: eventOut
              },
              style: style
            };
            $(el).qtip(options);
            if (attrs.qtipVisible) {
              scope.$watch('qtipVisible', function(new_val) {
                return $(el).qtip('toggle', new_val);
              });
            }
            if (attrs.qtipDisable) {
              scope.$watch('qtipDisable', function(new_val) {
                return $(el).qtip('disable', new_val);
              });
            }
            if (attrs.qtipTitle) {
              scope.$watch('qtipTitle', function(new_val) {
                return $(el).qtip('option', 'content.title', new_val);
              });
            }
            return scope.$watch('qtip', function(new_val, old_val) {
              if (new_val !== old_val) {
                return $(el).qtip('option', 'content.text', new_val);
              }
            });
          };
          if (attrs.qtipSelector) {
            $timeout((function() {
              return generateQtip($(scope.qtipSelector).html());
            }), 1);
          } else if (attrs.qtipTemplate) {
            $http.get(scope.qtipTemplate, {
              cache: $templateCache
            }).then(function(html) {
              return generateQtip({
                text: function() {
                  return $timeout(function() {
                    return scope.$apply(function() {
                      return $compile(html.data)(scope);
                    });
                  }, 1);
                }
              });
            });
          } else if (attrs.qtipTitle) {
            generateQtip({
              title: scope.qtipTitle,
              text: scope.qtip
            });
          } else {
            generateQtip({
              text: function() {
                return $timeout(function() {
                  return scope.$apply(function() {
                    return $compile("<div>" + content + "</div>")(scope);
                  });
                }, 1);
              }
            });
          }
          return void 0;
        }
      };
    }
  ]);

}).call(this);
