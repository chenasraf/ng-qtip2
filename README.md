# ng-qtip2

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/7b717aa5529c4798b3f13309ba713e25)](https://www.codacy.com/app/chenasraf/ng-qtip2?utm_source=github.com&utm_medium=referral&utm_content=chenasraf/ng-qtip2&utm_campaign=badger)

qTip 2 directive for AngularJS.

## Features
* Two way bind support for content and title
* Remote template file support
* Customizable delay, trigger types, position, CSS classes and tip position

## How to use
### Manually include

1. Make sure the file is included in your HTML:  

  ```html
  <script type="text/javascript" src="ng-qtip2.js"></script>
  ```
2. Load the `ngQtip2` module in your `app.js`'s configuration
  ```javascript
  angular.module('myApp', ['ngQtip2'])
  ```

### Using bower

1. Install with bower
  ```sh
  bower install ng-qtip2
  ```
2. Make sure the file is included in your HTML:
  ```html
  <script type="text/javascript" src="bower_components/ng-qtip2/ng-qtip2.js"></script>
  ```

### Overriding default options

You may override any options for qTip tips globally in your module.  
Do this by injecting `qtipDefaultsProvider` inside your app's `config` stage, and using the `setDefaults` method.  
Example config stage:

```javascript
angular.module('myApp', ['ngQtip2']).config(function(qtipDefaultsProvider) {
  qtipDefaultsProvider.setDefaults({
    position: {
      my: 'bottom center',
      at: 'top center'
    }
  });
});
```

## Available options

| Option | Type | Description |
|---|---|---|
| qtip | string (required) | The qTip content. This can be left blank and overridden with other properties such as `qtip-content`, `qtip-title`, `qtip-selector`, and `qtip-template`. |
| qtip-content | string | The qTip content. Overrides `qtip`. |
| qtip-title | string | When specified, puts the value in qTip's built-in title option. |
| qtip-visible | boolean (default: false) | Whether the qTip is visible immediately. |
| qtip-disable | boolean (default: false) | Whether the qTip is disabled completely. Useful with `ng-repeat` and conditions inside the repeater, for example. |
| qtip-fixed | boolean (default: true) | Whether the qTip sticks around after the mouse leaves it (up until a certain `qtip-delay` is reached) |
| qtip-delay | int (default: 100) | How long to wait before the qTip disappears after it becomes inactive when the `mouseleave` hide event is used (i.e, by default), in ms. |
| qtip-adjust-x | int (default: 1) | Position the qTip more to the left or right, relatively, in pixels. Use a negative value to move it left. |
| qtip-adjust-y | int (default: 1) | Position the qTip more to the top or bottom, relatively, in pixels. Use a negative value to move it up. |
| qtip-show-effect | boolean (default: true) | If `false`, will disable animating the showing effect of qTip (this is useful when the dynamic positioning shows a flicker and animates the qTip from the side of the element or screen before positioning it correctly). |
| qtip-hide-effect | boolean (default: true) | If `false`, will disable animating the hiding effect of qTip (this is useful when the dynamic positioning shows a flicker and animates the qTip from the side of the element or screen before positioning it correctly). |
| qtip-modal-style | object | Set inline style for the qTip. This should be a JS object that contains the JS-esque style properties (such as `maxHeight: '100vh'`) |
| qtip-tip-style | object | Set inline style for the qTip's tip. This should be a JS object that contains the JS-esque style properties (such as `maxHeight: '100vh'`), and may also contain tip specific implementations (such as `mimic`, and `corner`). |
| qtip-class | string | Classes to use for the qTip, you can use these to style the qTip easier with CSS. |
| qtip-selector | string | CSS selector for element to use. When specified, the element found using the selector and jQuery will override any other content specified. |
| qtip-template | string | Remote template to use for qTip. When specified, the template will be used for the qTip content and will override any other content specified. Use in conjuction with `qtip-template-object` |
| qtip-template-object | object | Will assign a model to the qTip template for use inside the template's content. You can reference this using `{{object}}` inside the template. |
| qtip-event | string (default: mouseover) | What event triggers the qTip to show up. |
| qtip-event-out | string (default: mouseout) | What event triggers the qTip to hide after being shown. |
| qtip-show | object | Object for the qtip 'show' option (see qTip docs). Will override `qtip-event` |
| qtip-hide | object | Object for the qtip 'hide' option (see qTip docs). Will override `qtip-event-out` |
| qtip-my | string (default: bottom center) | qTip bubble tip position relative to the qTip. "Put **my** tip **at** the qTip's..." |
| qtip-at | string (default: top center) | qTip bubble tip position relative to the qTip. "Put **my** tip **at** the qTip's..." |
| qtip-persistent | boolean (default: true) | If `false`, qTip will be re-rendered next time it is open. |
| qtip-options | object | Object for the entire qtip initializer. This will merge itself into the other options specified in this table, overriding any existing keys. This is to explicitly override any options that are not handled the way you expect within these options, or to use options that are not yet implemented. |
| qtip-api | object | An empty object to hold the API reference object.  [See below](#api-object) for api documentation |

## API Object
Access the api by adding a scope object to `qtip-api`

```html
<span qtip="Hi!" qtip-api="tip"></span>
```

And then access it in your code:

```js
$scope.tip.api().get("position.my")
```

Because of the way qtip2 works, *the API will not be available until you first render it*.
This means that it won't be ready until the user showed it (hovered on the associated directive), or you've passed to the options `qtip-options="{prerender: true}"` which will force qtip2 to render the qtip on page load.

#### ngQtip API methods

| Name | Description | Returns |
|---|---|---|
| isReady() | Returns true if the API object is ready for use, false otherwise | boolean |
| api() | Returns a qTip2 API object[^qtip-docs]. | object |
| apiPromise() | Returns a `$q` promise holding the api object upon resolve. [See example below](#api-promise) | object |

## Examples
#### 1. Regular qTip

  ```html
  <span qtip="Hi there, {{name}}!">{{name}}</span>
  ```

#### 2. Immediately visible qTip

  ```html
  <span qtip="Woah!" qtip-visible="true">Keanu</span>
  ```

#### 3. qTip from template, with multiple objects

  ```html
  <span qtip qtip-template="my_remote_template.html"
        qtip-template-object="{person: myPerson, callback: myCallback}">
      {{person.name}}
  </span>
  ```

##### my_remote_template.html

  ```html
  <span ng-click="object.callback(person)">
      Hi {{object.person.name}}, you are {{object.person.age | pluralize:'year'}} old!
  </span>
  ```

#### 4. Dynamic qTip position

  ```html
  <ul>
      <li ng-repeat="person in people track by $index"
          qtip="{{$index}}"
          qtip-my="{{getQtipMy($index)}}"
          qtip-at="top {{$index > 15 ? 'center' : 'bottom'}}">
          {{person.name}}
      </li>
  </ul>
  ```
    
#### 5. API Promise

    ```js
    $scope.tip.apiPromise().then(function(api) {
      console.log(api.get("content"));
    });
    ```

## Contributing

1. Fork this repository
1. Make the desired changes
1. Test your implementations, and that nothing was broken
1. To auto-compile JS from Coffee, copy `pre-commit.hook` to `.git/hooks`
1. Commit & Push to your fork (auto-compile should do its magic during commit)
1. Create a pull request

[qtip-docs]: http://qtip2.com/api
