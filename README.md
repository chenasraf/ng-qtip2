# ng-qtip2
qTip 2 directive for AngularJS.

## Features
* Two way bind support for content and title
* Remote template file support
* Customizable delay, trigger types, position, CSS classes and tip position

## How to use
### Manually include

1. Make sure the file is included in your HTML:  
    <pre><code>&lt;script type="text/javascript" src="ng-qtip2.js"&gt;&lt;/script&gt;</code></pre>
2. Load the `ngQtip2` module in your `app.js`'s configuration

### Using bower

1. Install with bower

        bower install ng-qtip2
2. Make sure the file is included in your HTML:

        <script type="text/javascript" src="bower_components/ng-qtip2/ng-qtip2.js"></script>

## Available options
`Interpolated` means you can assign expressions inside using `{{expression}}` format to create dynamic content.
`Non-interpolated` are immediately evaluated as they are. For example, `qtip-visible` expects a `boolean` condition expression inside (e.g. `qtip-visible="title.length > 0"` or `qtip-visible="true"`).

| Option | Type | Description |
|---|---|---|
| qtip | [required] [interpolated] [string] | The qTip content. This can be left blank and overridden with other properties such as `qtip-content`, `qtip-title`, `qtip-selector`, and `qtip-template`. |
| qtip-content | [optional] [interpolated] [string] | The qTip content. Overrides `qtip`. |
| qtip-title | [optional] [interpolated] [string] | When specified, puts the value in qTip's built-in title option. |
| qtip-visible | [optional] [boolean] [default=false] | Whether the qTip is visible immediately. |
| qtip-disable | [optional] [boolean] [default=false] | Whether the qTip is disabled completely. Useful with `ng-repeat` and conditions inside the repeater, for example. |
| qtip-fixed | [optional] [boolean] [default=true] | Whether the qTip sticks around after the mouse leaves it (up until a certain `qtip-delay` is reached) |
| qtip-delay | [optional] [string\|int] [default=100] | How long to wait before the qTip disappears after it becomes inactive when the `mouseleave` hide event is used (i.e, by default), in ms. |
| qtip-adjust-x | [optional] [int] [default=0] | Position the qTip more to the left or right, relatively, in pixels. Use a negative value to move it left. |
| qtip-adjust-y | [optional] [int] [default=0] | Position the qTip more to the top or bottom, relatively, in pixels. Use a negative value to move it up. |
| qtip-show-effect | [optional] [boolean] [default=true] | If `false`, will disable animating the showing effect of qTip (this is useful when the dynamic positioning shows a flicker and animates the qTip from the side of the element or screen before positioning it correctly). |
| qtip-modal-style | [optional] [object] [default={}] | Set inline style for the qTip. This should be a JS object that contains the JS-esque style properties (such as `maxHeight: '100vh'`) |
| qtip-tip-style | [optional] [object] [default={}] | Set inline style for the qTip's tip. This should be a JS object that contains the JS-esque style properties (such as `maxHeight: '100vh'`), and may also contain tip specific implementations (such as `mimic`, and `corner`). |
| qtip-class | [optional] [string] [default=''] | Classes to use for the qTip, you can use these to style the qTip easier with CSS. |
| qtip-selector | [optional] [string] [interpolated] | CSS selector for element to use. When specified, the element found using the selector and jQuery will override any other content specified. |
| qtip-template | [optional] [string] [interpolated] | Remote template to use for qTip. When specified, the template will be used for the qTip content and will override any other content specified. Use in conjuction with `qtip-template-object` |
| qtip-template-object | [optional] [anyObject] | Will assign a model to the qTip template for use inside the template's content. You can reference this using `{{object}}` inside the template. |
| qtip-event | [optional] [string] [interpolated] [default=mouseover] | What event triggers the qTip to show up. |
| qtip-event-out | [optional] [string] [interpolated] [default=mouseout] | What event triggers the qTip to hide after being shown. |
| qtip-show | [optional] [object] | Object for the qtip 'show' option (see qTip docs). Will override `qtip-event` |
| qtip-hide | [optional] [object] | Object for the qtip 'hide' option (see qTip docs). Will override `qtip-event-out` |
| qtip-my | [optional] [string] [interpolated] [default=bottom center] | qTip bubble tip position relative to the qTip. "Put **my** tip **at** the qTip's..." |
| qtip-at | [optional] [string] [interpolated] [default=top center] | qTip bubble tip position relative to the qTip. "Put **my** tip **at** the qTip's..." |
| qtip-persistent | [optional] [boolean] [default=false] | If `true`, qTip will be re-rendered next time it is open. |
| qtip-options | [optional] [object] | Object for the entire qtip initializer. This will merge itself into the other options specified in this table, overriding any existing keys. This is to explicitly override any options that are not handled the way you expect within these options, or to use options that are not yet implemented. |

## Examples
#### 1. Regular qTip

    <span qtip="Hi there, {{name}}!">{{name}}</span>

#### 2. Immediately visible qTip

    <span qtip="Woah!" qtip-visible="true">{{name}}</span>

#### 3. qTip from template, with multiple objects

    <span qtip qtip-template="my_remote_template.html"
          qtip-template-object="{person: myPerson, callback: myCallback}">
        {{person.name}}
    </span>

##### my_remote_template.html

    <span ng-click="object.callback(person)">
        Hi {{object.person.name}}, you are {{object.person.age | pluralize:'year'}} old!
    </span>

#### 4. Dynamic qTip position

    <ul>
        <li ng-repeat="person in people track by $index"
            qtip="{{$index}}"
            qtip-my="{{getQtipMy($index)}}"
            qtip-at="top {{$index > 15 ? 'center' : 'bottom'}}">
            {{person.name}}
        </li>
    </ul>

## Contributing

1. Fork this repository
2. Make the desired changes
3. Test your implementations, and that nothing was broken
4. Create a pull request
