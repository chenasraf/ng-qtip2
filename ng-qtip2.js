// Generated by CoffeeScript 1.10.0
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
          qtipClass: '@',
          qtipMy: '@',
          qtipAt: '@',
          object: '=qtipTemplateObject'
        },
        link: function(scope, el, attrs) {
          var event, eventOut, generateQtip, str2bool;
          str2bool = function(str) {
            var ref;
            return (ref = String(str).toLowerCase()) !== 'false' && ref !== '0' && ref !== 'null' && ref !== '';
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
            var options, ref, ref1, ref2;
            options = {
              position: {
                my: str2bool(scope.qtipMy) ? scope.qtipMy : 'bottom center',
                at: str2bool(scope.qtipAt) ? scope.qtipAt : 'top center',
                target: el,
                adjust: {
                  x: scope.qtipAdjustX != null ? parseInt(scope.qtipAdjustX) : 0,
                  y: scope.qtipAdjustY != null ? parseInt(scope.qtipAdjustY) : 0
                }
              },
              show: {
                event: str2bool(scope.qtipEvent) ? scope.qtipEvent : 'mouseover'
              },
              hide: {
                fixed: scope.qtipFixed !== null ? str2bool(scope.qtipFixed) : true,
                delay: (ref = scope.qtipDelay) != null ? ref : 100,
                event: str2bool(scope.qtipEventOut) ? scope.qtipEventOut : 'mouseout'
              },
              style: {
                classes: str2bool(scope.qtipClass) ? scope.qtipClass : 'qtip',
                tip: (ref1 = scope.qtipStyle) != null ? ref1 : {}
              }
            };
            options.content = content != null ? content : {
              text: (ref2 = scope.qtipContent) != null ? ref2 : scope.qtip
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
                      var text;
                      text = $compile(html.data)(scope);
                      return text;
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
