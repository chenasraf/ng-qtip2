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
          qtipMy: '@',
          qtipAt: '@',
          object: '=qtipTemplateObject'
        },
        link: function(scope, el, attrs) {
          var event, eventOut, generateQtip, string_to_bool;
          string_to_bool = function(str) {
            var ref;
            return !((ref = String(str).toLowerCase()) === 'false' || ref === '0' || ref === 'null');
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
            var options, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9;
            options = {
              content: (ref = scope.qtipContent) != null ? ref : scope.qtip,
              position: {
                my: (ref1 = scope.qtipMy) != null ? ref1 : 'bottom center',
                at: (ref2 = scope.qtipAt) != null ? ref2 : 'top center',
                target: el,
                adjust: {
                  x: (ref3 = parseInt(scope.qtipAdjustX)) != null ? ref3 : 0,
                  y: (ref4 = parseInt(scope.qtipAdjustY)) != null ? ref4 : 0
                }
              },
              show: {
                event: (ref5 = scope.qtipEvent) != null ? ref5 : 'mouseover'
              },
              hide: {
                fixed: scope.qtipFixed !== null ? string_to_bool(scope.qtipFixed) : true,
                delay: (ref6 = scope.qtipDelay) != null ? ref6 : 100,
                event: (ref7 = scope.qtipEventOut) != null ? ref7 : 'mouseout'
              },
              style: {
                classes: (ref8 = attrs.qtipClass) != null ? ref8 : 'qtip',
                tip: (ref9 = scope.qtipStyle) != null ? ref9 : {}
              }
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
