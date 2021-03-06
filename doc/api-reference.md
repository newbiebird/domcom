## document API reference

## introduction to this document

### notations and conventions

#### function prototype notation

	functionName arg1[: Type1], arg2[: Type2], ...

	functionName()

#### method prototype notation

	object.methodName arg1[: Type1], arg2[: Type2], ...

	object.methodName()

Here the [] represents that the content can be omitted.The occurences of [...] in the function or method prototype of the following documents represent array type or optional content, according to the context.

Depending on the context, if the type is obvious, not convenience or not necessary to decript it, then the type description will be omitted.

The notations above applies to the next section(type description) and the function or method Prototype instructions in the following document.

### type description

This type decription is just an informal specification, to help us understand the documentation and write code. It should not be used as a precise formalism.

The following are some of the types which will occur in the prototype description:

* item:toComponent:    item can be any value, but item will be converted to a proper component by toComponent(item)

* value:domField:    value can be any value, but value will be converted to a property value of the dom node by domField(value)

* fn:Reactive:    fn is a reactive function

* x:Any:    x can be any type

* items:[Type]:    items is an array with Type as its element type

* Array:    array type

* items:[Type1, Type2, ...]:    items is an array, Type1 element and Type2 element occur sequencially in pairs in the array

* hash:Hash:     hash is an oject, and is not array or null

* item: HashValue:    item is the value of Hash, the Hash object generally should be a parameter of a relative function, or a field of the hosted object

* item: HashKey:    item is the key to Hash object,  the Hash object generally should be a parameter of a relative function, or a field of the hosted object

* item: Set:    item is a set, the values in it should be always true or 1

* fn:(param1[: Type1] [, param2[: Type2] [, ...] ]) -> [Type]:    function type

* item:Type1|Type2:    item can be the value of Type1 or Type2

* item:ValueReactive:     item can be any value or a reactive function. if item is a ordinary function, it will be converted to a renew reactive function

* attrs:Attrs:    attrs can be used ad the attrs of Tag component, `isAttrs(attrs)`(defined in core/util.coffee) should be true

* item: Index:    item is the subscription of array. The array generally should be a parameter of a relative function, or a field of the hosted object

* item: Boolean:  item is Boolean type

* item: Int:  item is integer type

* item: String:    item is a string

* item: Promise:    item is a Promise, it should has .then and .catch method

* item:TagName:    item is a string which can be used as tag name in html, e.g. div, custom-tag, etc

* item:PropName:    item is proper name for Node property or the Style of the Node

* item:PropSet:    item is a Hansh from PropName map to property value, the value is domField type

* item:ClassFn:    item is the value or values' list for className(or class) ，all the values will be used as the parameters for classFn, merged to be set to the value of className property

### about the methods 

This document only describe public method, including the public method in classes, class instances, object or modules

************************************************************************

## get Domcom, setup html pages, use Domcom API

### get Domcom
  npm install --save domcom

  git clone https://www.github.com/taijiweb/domcom

  download from github releases: [Github releases](https://github.com/taijiweb/domcom/releases)

  use the cdn: use this cdn link(thanks to cdn.jsdelivr.net):

    http://cdn.jsdelivr.net/domcom/0.1/domcom.min.js

### setup html pages for Domcom

  According to the requirements for developping or application, choose one of the files(domcom.js, domcom.min.js, domcom-basic.js or domcom-basic.min.js) from the domcom/dist/ folder after installing or cloning or downloading, add the script tag to html page like below:

    `<script src="path/to/domcom.min.js"/>`

  If you prefer to use the cdn link provided by cdn.jsdelivr.net, then you should add the script tag like below:

    `<script src="http://cdn.jsdelivr.net/domcom/0.1/domcom.min.js"/>`

  And then add the javascript script tag after domcom script tag:

    `<script src="path/to/my-app.js"/>`

### import and refer to the api in domcom

dc will become global variable hooked under window in th browser, after adding the domcom's `<script>` tag, i.e. window.dc. I recommend to use Coffee-script, or to use babel for the supporting to ES6 syntax. With them the domcom api can be refered like below:

	{see, div, list, if_} = window.dc

#### ES 6

With the help of the tools like webpack or browserify and by using babel.js, the syntax of ES6 like below also can be used:

    {see, div, list, if_} = dc = require('domcom')

Or require the single module respectively ( this is NOT suggested):

    {see} = require('domcom/src/flow'
    {div} = require('domcom/src/core/')

### the native ES5 syntax

If you only prefer to the native ES5 syntax and not use any tools above, the method below can be used:

	var see = dc.see, div = dc.div, if_ = dc.if_;

or like below:

	dc.see(1); dc.div({}, "hello"); dc.if_(x, "hello",  "hi")

These are obviously not ideal. I still suggest to use Coffee-script or ES6.

***********************************************************

## API reference

### components

The component is the core concept in the structure of Domcom. The domcom framefork uses the components to proxy and manipulate dom nodes. Every component will generate their respective dom nodes or empty node. The components can be divided to two categories by their base classes: base compnoents and transform components. The base components manipulate dom nodes directly, and they have the methods to create or refresh dom, attach/detach node. The most important method for the transform components is getContentComponent, which converts the compnent to a base componet step by step. With components, domcom give a complete declarational description to dom, including node, node perperty, node events, and so on. Besides, Domcom creates the static or dynamic interactive relations between the dom and the date by using value or reactive functions, and induce the method to update the components and to refresh dom, to improve the performance.

***********************************************************

#### Component base class: Component

This is the base class of all components. It provides the common method for component classes. In them, the mount, unmount and remount method manipulate, the render and update method are used to create, render or update the components, the renderWhen and updateWhen method can set the schema to render or update the component; the on, off and emit manage the component events.

##### Component method
* **mount，unmount，remount**

  > function prototype: component.mount mountNode: Null|domNode, beforeNode: Null|domNode`

  Mount component. If dom node does not exists, the node will be created before mounting. mountNode is the parentNode to be mounted to. If ommited, document.body will be used. beforeNode will become the next siblings node of the comonent's node. Suppose the real parentNode to be mounted to is parentNode，the created component node is node, then the code for mounting is: `parentNode.insertBefore(node, beforeNode)`

  > function prototype: `component.unmount()`

  Detach compnent, i.e. detach the component node from the dom.

  > function prototype: `component.remount()`

  Remount the component agian, i.e. remount the dom node to dom again, and keep the parentNode and the nextNode not being changed.

* **render，update**

  > function prototype: `component.render()`

  Render compnent. If dom node does not exists, the node will be created at first. If the dom node exists, and the component was invalidated, proper updation will be executed. If the component is valid, but the parent node of its dom node(`component.node.parentNode`) is not the parentNode of the component itself(`component.parentNode`), the dom node will be attached to component.parentNode and before `component.nextNode`, again.

  > function prototype: `component.update()`

  Update compnent. The only difference between this method and the previous mehtod(component.render) is this mthoed will call `component.emit('update')` at first.

* **renderWhen，updateWhen**

  Set the opportunity to update the component, which can be som dom events on some component, or window.setInterval, dc.raf. The type declaration for the two methos are below: 

  > function prototype:  `component.renderWhen components:[Component]|Component, events:[DomEventName], options`

  > function prototype:  `component.updateWhen components:[Component]|Component, events:[DomEventName], options`

  When the dom events on components happen, component will be rendered or updated. If dc.config.useSystemUpdating is true, ，then the render or the updatioin configured by this method will not be done, except options.alwaysUpdating is true.

  > function prototype:  `component.renderWhen event:setInterval, interval:Int(ms), options`

  > function prototype:  `component.renderWhen event:setInterval, interval:Int(ms), options`

  Use window.setInterval function to render or update the component once every interval milliseconds. In the options parameter, a test function can be set to check at first whether to render or update, a clear function can be used to stop render or update by clearInterval. The code below can be used to help us understanding this:

	addSetIntervalUpdate = (method, component, options) ->
	  handler = null
	  {test, interval, clear} = options
	  callback = ->
	    if !test or test() then component[method]()
	    if clear and clear() then clearInterval handler
	  handler = setInterval(callback, interval or 16)


  > function prototype:  `component.renderWhen event:dc.render, options`

  > function prototype:  `component.renderWhen when:dc.render, options`

  Tell dc.render rendering or updating the component。In the options parameter, a test function can be set to check at first whether to render or update, a clear function can be used to stop rendering or updating. The code below can be used to help us understanding this:

	addRenderUpdate = (method, component, options) ->
	  {test, clear} = options
	  callback = ->
	    if !test or test() then component[method]()
	    if clear and clear() then dc.offRender callback
	  dc.onRender callback

* **on, off, emit**

  This three method manipulate the event happening on this compnent. This kind of events are called component event, which are different from the dom event, and are provided by the domcom framework. Compnent event mechanism is indepent completely from the dom event mechanism. The component events are registered in the Component.listeners by Component.on, off, and emitted by the emit method. The domcom framework emits a group of component events internally, including beforeMount, update, afterUnmount, beforeAttach, contentChanged etc.

  > function prototype: `component.on event, callback`

  Register component event callback funciton(callback), the component object will become the "this" context of the callback.

  > function prototype:  `component.off event, callback`

  Remove the registered callback from the listeners of the component,  with "event" as the event name.

  > function prototype:  `component.emit event, args...`

  Execute all the callback which are registed on the parameter event, For every callback, run `callback.apply(component, args)`

* **clone**

  Although this method is not defeind on the Component class itself, but All of the bulitin classes in domcom almost always define this method. The derived compnent classes should define this method if they need be cloned or copied. The clone method can make a copy of itself. When the compnent need be used in multiple places, but should not be referenced directly( which may causes the conflicting dom node), this method may be useful.

  > function prototype: `component.clone()`


* **toString**

  Although this method is not defined on the Component class itself,But All of the bulitin classes in domcom almost always define this method. It mainly is used to help debugging.

  >  function prototype: `component.toString indent:Int=0, addNewLine:Boolean`

***********************************************************

#### component utilities

#### toComponent

  Convert anything to component. If it is a component, return itself; if it is a function, return a Text Component, the text field is a reactive function; if it is an array, return a List component; if it is  a promise, return a proxy reactive function to the promise; if it is null or undefined, return a Nothing component; otherwise return a Text component.

##### function's type

  > function prototype: `toComponent item:Any`

##### implementation

	toComponent = (item) ->

	  if isComponent(item) then item

	  else if typeof item == 'function' then new Text(item)

	  else if item instanceof Array
	    new List(for e in item then toComponent(e))

	  else if !item? then new Nothing()

	  else if item.then and item.catch
	    component = new Func react -> component.promiseResult

	    item.then (value) ->
	      component.promiseResult = value
	      component.invalideTransform()

	    item.catch (error) ->
	      component.promiseResult = error
	      component.invalideTransform()

	    component

	  else new Text(item)

#### toComponentList

  Convert anything to an array of component. 

##### function's type

  > function prototype: `toComponentList item:Any`

##### implementation

	module.exports = toComponentList = (item) ->
	  if !item then []
	
	  else if item instanceof Array
	    for e in item then toComponent(e)
	
	  else [toComponent(item)]

#### isComponent

  Check whether anything is a component.

##### function's type

  > function prototype: `isComponent item:Any`

##### implementation

	isComponent = (item) -> item and item.renderDom

***********************************************************

#### the base class for all base components: BaseComponent

  The base components have some method to manipulate the dom directly, including createDom, updateDom，attachNode，removeNode, etc. Most of the base components will generate dom nodes directly, but List component will indirectly generate dom nodes throught their children components, empty List components(`children.length==0`)and Nothing component will not generate the real dom node ,and use an empty arrar "[]" to represent it instead. The field for dom node is component.node. This field for Tag, Text, Comment is the real dom node; this field for Html is an array, including a group of real dom node, the dom node field for List is an array including the real dom node or the node for other List.

##### module: Core/Base/BaseComponent

##### direct super class: Component

##### subclasses: List, Tag, Text, Html, Comment, Nothing

##### constructor and instantiate function

  Do NOT use BaseComponent object directly

***********************************************************

#### list component: List

##### module: Core/Base/List

##### direct super class: BaseComponent

##### subclasses: Tag

##### constructor
  > function prototype: new List(children: [toComponent])

##### instantiate function

  > function prototype: list children...: [toComponent]

##### sample
	list \
	    label "user name: ",
	    text placeholder: "input here: ", value: username$

##### other instantiate function: every, all, nItems

  every, all or nItems will also return an instantiation of list component.

  > function prototype: `every arrayItems:[Any], itemFn:(item:Any, index:int, arrayItems:arrayItems!) -> toComponent`

  > function prototype:  `all objectItems:Hash, itemFn:(value, key, index:Index, objectItems!) -> toComponent`

  > function prototype:  `nItems n:Int|Function|Reactive, itemFn:(value, key, index:Index, objectItems!) -> toComponent`

  itemFn is called as component template function, which will return a component, if the return value is not component, it wil be converted to component by using toComponent function.

##### List method

  The list components provide a group of methods to manipulate its children dynamically, which can add or remove the child component in its children field. Please notice that these methods will not affect the dom immediately, instead, they set invalidateIndexes and invalidate the list component at first, and the dom will be refreshed until the render or update method of the component is called. Most of time these method may do NOT need be used, except while customing or extending the components. It is suggested not to imperatively and directly modify the compnent structure by using these methods as possible.

* **pushChild**

  Push a child compnent to the tail of List.children.

  > function prototype: `component.pushChild child:toComponent`


* **unshiftChild**

  Unshift a child component to the front of List.children.

  > function prototype: `component.unshiftChild child:toComponent`

* **insertChild**

  Insert a child component at the index location of List.children的index.

  > function prototype: `component.indexChild index:Index, child:toComponent`

* **removeChild**

 Remove the child component at the index location of List.children

  > function prototype: `component.removeChild index:Index`

* **setChildren**

  Set the components in newChildren to the respective location stated at startIndex of List.children

  > function prototype: `component.setChildren startIndex:Index, newChildren:[toComponent]...`

* **setLength**

  The length of List.children is set to newLength, the child component stated from newLength will be removed. IfnewLength is greater or egual to the old length of List.children, this method will do nothing.

  > function prototype: `component.setLength newLength:Int`

***********************************************************

#### tag component: Tag

##### module: Core/Base/Tag

##### direct super class: List

##### constructor function
  > function prototype: new Tag(tagName, attrs, children)

##### instantiate function

  > function prototype: `dcTagName([attrs:Attrs] [, children:[toComponent]...])`
  
  dcTagName is a function which can instantiate a component, and it must be imported form the dc namespace before being used, e.g. div, p, span, input, textarea, select, etc.

  > function prototype: `inputType([attrs:Attrs][, value:domField])`

  inputType is a proper type value for <intput>, including text, number, checkbox, radio, email, date, tel, etc.

  On the complete list for dcTagName and inputType, please see src/core/tag.coffee.

  > function prototype: `tag tagName:TagName [attrs:Attrs][, children:[toComponent]...]`

  tagName is any string which can be used as a html tag.

##### samples

    span "hello"
    li -> x

	text({$model: model}), select $options:[['domcom', 'angular', 'react']]

	input {type:"text", value: who$, onchange: -> alert "hello, "+who$()}


##### Tag component method

  Tag component is used for the Element node in the dom. It can manipulate the dom node properties, Css Style, Dom events and so on. The properties defined on Tag component is reactive, i.e. if their values is a function, which will  become reactive function. The Tag component need be updated only while the reactive function is invalidated. While updating, The new value of the computation will be compared to the cached value, when and only when they are different, the dom node properties will be modified and dom operations will be executed to refresh. Dom events is the events which happen on the dom node. They are not domcom component events. The dom events include onclick, onchange and so on. For processing dom Dom, domcom mainly take use of the declaration through the attrs parameter while constructing Tag component, in the meanwhile, The two methods, Tag.bind, Tag.unbind can be used. Besides, some directives, the methods such as Component.renderWhen, Component.updateWhen, dc,renderWhen, dc,updateWhen can also add dom event handler functions.

  Most of the methods on Tag components do not directlye operate on the dom, so they will not immediately take affect, and the dom will not be refreshed until the call to the render of update method to the tag component or their holder components. No dom operation will be executed if the new value is equal to the cached value of the property. Domcom imrove the performance the web application by this kind of mechanism. The Tag component methods include prop, css, addClass, removeClass, show, hide etc.

  Tag.bind, Tag.unbind are different from the description above. These two method will operate on the event callback array for the event handler of the dom node, and will affect the behaviour of the dom node event. If the first event callback is added or the last is removed, then the event handler of the dom node event will be assigned to null. Because the modification to event property of dom node will not cause dom redraw or reflow, so this behavior will not affect the performance.

* prop

  > function prototype: `tag.prop prop:PropName|PropSet, value: domField`

   If the arguments length is 1, and if the prop is property name, then the property value will be returned, if the prop is the hash of properties and their values, this method wil extend the properties with prop. If the arguments length is 2, then this method will set the property (tag.props[prop]=value).

   prop: property name, or the hash of properties and values

   value: undefined or the property value. It can be reactive funciton. If it is reactive function, then the value for the propety of the dom node ( tag.node[prop] ) will always keep consistent with the value of function.

* css

  > function prototype: `tag.css prop:PropName|PropSet, value: domField`

  If the arguments length is 1, and if the prop is property name, then the style property value (tag.style[prop]) will be returned, if the prop is the hash of properties and their values, this method wil extend the style properties (tag.props.style) with prop. If the arguments length is 2, then this method will set the style property (tag.style.props[prop]=value).

  prop: style property name, or the hash of style properties and values

   value: undefined or the style property value. It can be reactive funciton. If it is reactive function, then the value for the style propety of the dom node ( tag.node.style[prop] ) will always keep consistent with the value of function.

* addClass, removeClass

  > function prototype: `tag.addClass items: [ClassFn]...`

  > function prototype: `tag.removeClass classes:[ClassName]...`

* show, hide

  > function prototype: `tag.show [display]`

  > function prototype: `tag.hide()`

* bind, unbind

  > function prototype: `tag.bind eventName, handlers:DomEventHandler`

  > function prototype: `tag.unbind eventName, fn`

  bind or unbind the event callback fn for the event of eventName on the component's dom node. Domcom will collect all the event callbacks to one array and generate the real event handler function, set this handler to the dom node's the eventName property.

  The callback fn will be called like so: callback.call(node, event, component), and the tag component's dom node will become "this" context to the callback fn, event is the real dom event, component is this tag component. When all the event callbacks are processed, event.preventDefault() and event.stopPropagation() will be executed, except that event.executeDefault or event.continuePropagation is set to true.

  The code for the composed event handler from event callbacks is like below:

	eventHandlerFromArray = (callbackList, eventName, component) ->
 		(event) ->
			node = component.node
			for fn in callbackList then fn and fn.call(node, event, component)
			updateList = component.eventUpdateConfig[eventName]
			if updateList
			 for [comp, options] in updateList
			   # the comp is in updateList, so it need to be updated
			   # if config.useSystemUpdating then update this component in dc's system update scheme
			   if options.alwaysUpdating or !config.useSystemUpdating then comp[options.method]()
			if !event then return
			!event.executeDefault and event.preventDefault()
			!event.continuePropagation and event.stopPropagation()
			return


***********************************************************

***********************************************************

### text component: Text

##### module: Core/Base/Text

##### direct super class: BaseComponent

##### subclasses: Html, Comment

##### constructor function

  > function prototype:  `new Text text:domField`

##### instantiate function

  > function prototype:  `txt [attrs:Attrs, ]string:domField`

##### explanation

  If any parameter or any field which needs a component is given a non component value, then the value will be converted to Text component, except that the value is undefined or null.

##### sample

  div 1; p "hello", who$; li someVariable; span -> someVariable  # （1）


***********************************************************

### Html component: Html

##### module: Core/Base/Html

##### direct super class: Text

##### constructor function

  > function prototype:  `new Html htmlText:domField[, transform:(String) -> String]`

##### instantiate function

  > function prototype:  `html [attrs:Attrs, ]htmlText:domField[, transform:(String) -> String]`

##### sample

	html "<div> This is domcom </div> <div> That is angular </div>"
	html someHtmlTextString, escapeHtml


***********************************************************

### comment component: Comment

##### module: Core/Base/Comment

##### direct super class: Text

##### constructor function

  > function prototype: new Comment text:domField

##### instantiate function

  > function prototype: comment text:domField

  Comment component instantiate function is not provided attrs:Attrs parameter.

##### sample

	comment "this is a comment"


***********************************************************

### CDATA component: Cdata

  CDATA is not supported by html, but supported by xhtml and xml.

##### module: Core/Base/Cdata

##### direct super class: Text

##### constructor function

  > function prototype: new Cdata text:domField

##### instantiate function

  > function prototype: cdata text:domField

  CDATA component instantiate function is not provided attrs:Attrs parameter.

##### sample

	cdata "this is a CDATA text"


***********************************************************

### nothing component: Nothing

##### module: Core/Base/Nothing

##### direct super class: BaseComponent

##### constructor function

  > function prototype: new Nothing()

##### instantiate function

  > function prototype: nothing()

  Nothing component instantiate function is not provided attrs:Attrs parameter.

##### 说明

  When item in toComponent(item) is null or undefined, Nothing component will be created.


***********************************************************



#### transform component base class:  TransformComponent

  Transform component has getContentComponent method. The getContentComponent method will be called before rendering to get the content component, and then it is decided how to render. Transform component is chained to the base component by it's conent component, and chained to the dom node. the dom node field is component.node.

##### module: Core/Base/TransformComponent

##### direct super class: Component

##### subclasses: If, Case, Cond, Func, Each, Route, Defer

##### constructor function和instantiate function

  Do not use transform component object.

***********************************************************


### Ifcomponent: If

##### direct super class: TransformComponent

##### module: Core/Base/If

##### constructor function

  > function prototype:  `new If test:ValueReactive, then_:toComponent[, else_:toComponent]`

##### instantiate function

  > function prototype:  `if_ [attrs:Attrs, ]test:ValueReactive, then_:toComponent[, else_:toComponent]`

  else_ is optional. If else_ is omitted, then the else_ field of If component will be Nothing component.

##### sample

	x = see 0, parseFloat
	comp = list \
        text({onchange: -> comp.update()}, x)
        if_(x, div('It is not 0.'), div('It is 0 or NaN.')))

***********************************************************

### Case component: Case

##### module: Core/Base/Case

##### direct super class: TransformComponent

##### constructor function

  > function prototype:  `new Case test:ValueReactive, caseMap:Hash[, else_:toComponent]`

##### instantiate function

  > function prototype:  `case_ [attrs:Attrs, ]test:ValueReactive, caseMap:Hash[, else_:toComponent]`

##### sample

    case_(x, {
        A: "Angular",
        B: "BackBone",
        D: "Domcom",
        E: "Ember",
        R: "React"
    },  "some other")

***********************************************************

### Pick component: Pick

##### module: Core/Base/Pick

##### direct super class: TransformComponent

##### constructor function

  > function prototype:  `new Pick host:Object, field:String [, initialContent:toComponent]`

##### instantiate function

  pick does not support "attrs" parameter, because host must be an object.

  > function prototype:  `pick host:Object, field:String [, initialContent:toComponent]`

##### sample

    pick(host={}, 'activeField', 1)

***********************************************************

### Cond component

##### module: Core/Base/Cond

##### constructor function

  > function prototype:  `new Cond testComponentPairList:[Reactive, toComponent, ...][, else_:toComponent]`

##### instantiate function

  > function prototype:  `Cond attrs:Attrs, testComponentPairList:[Reactive, toComponent, ...][, else_:toComponent]`


***********************************************************

##### Func component

##### module: Core/Base/Func

##### constructor function

  > function prototype:  `new Func func:Function|Reactive`

##### instantiate function

  > function prototype:  `func [attrs:Attrs, ]func:Function|Reactive`


##### sample

	x = 0
	comp = null
	indexInput = number({onchange: -> x = parseInt(@value); comp.render()})
	comp = list(indexInput, func(-> if x>=0 and x<=3 then div x))

***********************************************************

### Each component

##### module: Core/Base/Each

##### constructor function

  > function prototype:  `new Each attrs:Attrs, items:[Any]|Reactive->[Any][,options:Options]`

##### instantiate function

  > function prototype:  `each [attrs:Attrs, ]items:[Any]|Reactive->[Any][,options:Options]`

##### sample

***********************************************************

#### Route component

##### module: Core/Base/route

##### constructor function

  > function prototype:  `new Route routeList, otherwise, baseIndex`

  It is not necessary to use Route constructor function directly at most of time. It is always more convenient to use route instantiate function, which has "route.to" method, but Route class has not.

##### instantiate function

  > function prototype:  `route routeList:[RoutePattern, RouteHandler...], [otherwise: toComponent][, baseIndex]`

  RoutePattern is the route pattern string or the route pattern string and the test funciton. The route pattern string can include query field name(the identifer lead by colon:) and regexpt, the wildcard characters(* or **) and general string.

  RouteHandler is the function with the type below:

  > function prototype:  `(match:RouteMatchResult, childRoute: RouteInstantiateFunction) -> toComponent`

  RouteMatchResult's type is below:
    {
      items: the matched query field
      basePath: the base path of the route
      segment: [String]: the matched string segments of the path
      leftPath: String:  the left string of the path after matching
      childBase: Int: the base index for the child route component instantiate function
    }

  route and childRoute has the "to" method, which can be used to set `location.href` or `window.history`.

  > function prototype:  `route.to path:RelativePath|AbsolutePath`

  > function prototype:  `childRoute.to path:RelativePath|AbsolutePath`

##### sample

    comp = route(
      'a/*/**', (match, route2) ->
        route2 1, (-> 1),
          2, -> 2,
          3, -> 3
          otherwise: 'otherwise 2'
      'b/**', -> 'b/**'
      otherwise: 'otherwise 1'
    )

***********************************************************

### Defer component

##### module: Core/Base/Defer


##### constructor function

  > function prototype: new Defer
        promise:Promise
        fulfill:((value, promise, component) -> toComponent)
        [reject: ((value, promise, component) -> toComponent)
        [init:toComponent]]

##### instantiate function

  > function prototype: defer attrs:Attrs,
        promise:Promise
        fulfill:((value, promise, component) -> toComponent)
        [reject: ((value, promise, component) -> toComponent)
        [init:toComponent]]

***********************************************************

***********************************************************

### reactive function

  The reactive function in domcom is lazy. invalidation should not trigger any real computation except changing valid state.

  (UPDATE: the reactive function is implemented in domcom before, but now they have been published as npm packages: lazy-flow, lazy-flow-at and dc-watch-list, and imported to domcom).

  The reactive function is the key to domcom different from other frameworks. Everything that connecting to data in Domcom, including Dom properties, If, Case, Cond component's test field, Func component's func field, Each component's items field, etc, can be reactive functions. Reactive functions have invalidateCallbacks field, which contains a list of invalidate callbacks, also the invalidate and onInvalidate methods, onInvalidate is used to register invalidate callback，invalidate is used to emit the excuection of all registed callbacks by onInvalidate.

  The reactive functions can be generated by using reactive function generator.

  All the methods relating to reactive functions in domcom are defined in the folder domcom/srs/flow/, all of the method is defined in the namespace dc.flow, can be refered through flow.someName or {someName,...} = dc.flow. For convenience, the frequently used names in flow/index module are also imported to dc namespace, so they can be refered by dc.someName or {someName,...} = dc, too.

#### flow/index module

##### react

* function prototype: ``

##### reactive.invalidate

* function prototype: ``

##### renew

* function prototype: ``

##### dependent

* function prototype: ``

##### flow

  * function prototype: ``

##### pipe

  * function prototype: ```

##### see

  * function prototype: `see value: Any[, Transform:(Value) -> Any]`

  * sample

    username$ = see "Tom"

    num1$ = see 1,
    num2$ = see 2

##### seeN

  * function prototype: ``


##### bind

  * sample

	score = { name: "Tom", points:95}

	name$ = bind(scores, "name")

##### duplex

	points$ = duplex(scores, "points")

##### unary

##### binary

****************************************************************************

#### flow/watch-list module

##### watchEachList

##### watchEachObject

****************************************************************************

#### flow/addon module

  The functions below will generate reactive functions with their parameters:

##### auto bindings

  Generate a group of single way binding (flow.bind) and double way binding (flow.duplex) from the model, the suffix of single way binding is "_", the suffix of single way binding is "$"

  > function prototype: bindings model:Object[, debugName:String]

  debugName parameter is optional, which is used by toString of the generated reactive function

  See the code below:

    dc.bindings = flow.bindings =  (model, name) ->
      result = {}
      for key of model
        result[key+'$'] = duplex(model, key, name)
        result[key+'_'] = bind(model, key, name)
      result

  * sample: 

     m = {a:1, b: 2}
     bindings$ = bindings m

     {a_, b$} = m

##### unary operations
  neg， no， bitnot， reciprocal，abs， floor，ceil， round

##### binary operations
  add， sub，mul，div，min

##### ternary operations(aka conitional test)
  flow.if_(test, then_, else_)

 flow.if_ is different from if_ component instantiate function, which generate a If component. Please always use flow.if_ to avoid confusing.

******************************************************************

### domcom utilities

#### DomNode class

#### dc utilties

#####  module: domcom/src/dc

##### methods on dc object

* dc

  > function prototype: `dc element: DomSelector|Node|[Node]|NodeList, options={}`

  generate an instantiation of DomNode

  e.g. dc(document), dc("#demo"), dc(".some-class")

* dc.directives

  register one directive or multiple directives. Please the section "Directive" for the description to directive.

* dc.onReady

  > function prototype: `dc.onReady fn:Callback`

  Register the callbacks which will be executed when dc.ready() is called.

* dc.ready

  Execute the callbacks registered by dc.onReady.

  > function prototype: `dc.ready()`


* dc.onRender

  Register the callbacks which will be executed when dc.render is called.


  > function prototype: `dc.onRender callback:Callback`

* dc.offRender

  Remove the callback registered by dc.onRender.

  > function prototype: `dc.offRender callback:Callback`

* dc.render

  Execute all the callbacks registered by dc.onRender.

  > function prototype: `dc.render()`


* dc.renderLoop

  Run `dc.render()` periodly (about 16ms) by calling requestAnimFrame( or the polyfill for it.

  > function prototype: `dc.renderLoop()`

  Below is the code for dc.renderLoop, in domcom/src/dc.coffee:

	dc.renderLoop = renderLoop = ->
	  requestAnimFrame renderLoop
	  render()
	  return

* dc.renderWhen和dc.updateWhen


##### dc properties

* dc.$document

  It is the same as window.$document, i.e. dc.$document = dc(window.document)

* dc.$body

  It is the same as window.$body), i.e. dc.$body = dc(window.body)


#### Tag property utilties

#####  module: src/core/property

##### explanation

  Some utilities to process the class, style and other properties of the Tag components, including classFn, styleFrom, extendAttrs, etc.

##### classFn

  > function prototype: classFn: items: [classFnType]...

  classFnType is a recursive type, here is its definition: `ClassName|MultipleClassNames|classFn(...)|classFnType`


#### styleFrom

  > function prototype: styleFrom value

    value: A style string like "stylePropName:value; ...",
      or: an array including the items like "stylePropName:value"
      or: an array including the items like [stylePropName, value]


##### extendAttrs

  > function prototype: extendAttrs toAttrs:Attrs|Null, fromAttrs:Attrs|Null

  > function prototype: overAttrs fromAttrs:Attrs|Null, toAttrs:Attrs|Null

    toAttrs: the propeties hasn to be extended. If it is null or undefined, a new object will be created.

    fromAttrs: the newproperties is used to extend old properties

##### extendEventValue

  > function prototype: extendEventValue props, prop, value, before

    props: events properties of the component

    prop: event name, like "click", "onclick", etc. If the prefix "on" is omitted, then "on" will be added by domcom.

    value: event callback or an array of event callback

    before: If it is truthy, value will be added before the original event callback array, otherwise after the original event callback array. The default value is false.

***********************************************************

#### utilties in util module

#####  module: domcom/src/util

  (UPDATE: this module has been published as dc-util and imported to domcom).

  Domcom implements this group functions to provided for the framework itself. It is not intended to be used as general utilities. Please choose them according to your user case.

##### isArray

  Check whether any item is an array.

* function type

  > function prototype: `isArray item:Any`

* implementation code:

  As a reference, the current code is listed as below. It probably be modified afterwards. The code is in domcom/src/util.coffee:

	exports.isArray = (item) -> Object.prototype.toString.call(item) == '[object Array]'


##### cloneObject

  copy an object

* function type

  > function prototype: `cloneObject obj:Object`

##### pairListDict

  Make an object (or call it hasn, dictionary) by copying the pairs in the array list.

* function type

  > function prototype: `pairListDict keyValuePairs[key, value, ...]...`

##### newLine

  Return a string with a leading new line and some indent spaces.

* function type

  > function prototype: `newLine str:String, indent:Int, addNewLine:Boolean`

##### isEven

  Check whether a number is even.

* function type

  > function prototype: `isEven n:Int`

##### intersect

  Return the inersect of two sets. The set is just hash with true or 1 as the value of all keys

* function type

  > function prototype: `intersect maps:[Set]`

##### substractSet

  Return the difference of two sets. The set is just hash with true or 1 as the value of all keys

* function type

  > function prototype: `substractSet whole: Set, part:Set`

##### binarySearch

  Search item from the sorted items by using binary search. If the item exists, the index of the item is returned, otherwise the index to insert the item is returned.

* function type

  > function prototype: `binarySearch item:Sortable, items[Sortable]`

##### binaryInsert

  Insert item into the sorted items by using binary search. If the item exists, the index of the item is returned, otherwise the index to insert the item is returned.

  Domcom uses binarySearch and binaryInsert to improve the performance in modifying the children in List component

* function type

  > function prototype: `binaryInsert item:Sortable, items[Sortable]`

##### numbers

  If n is integers (it should be greater than or equal to 0), the numbers from 0 to n-1 is returned, If n is a function, then a reactive function n is returned, which depends on n and return 0 to n()-1

* function type

  > function prototype: `numbers n:Int|Function|Reactive`

**********************************************

#### dom-util utilities

#####  module: domcom/dom-util

##### domField

  If the value is undefind or null, "" is returned; if the value is normal function, renew reactive function is returned; if the value is a reactive function, the value itself is returned; if the value is Promise (which has then method and catch method), a reactive function is returned to proxy the promise. In other cases the value itself is returned (because domField is used as Dom properties, so it will be converted to string by calling toString method because the feature of Javascript language itself).

  domField is generally called by domcom automatically, the user does not need to call this method directly.

* function type

  > function prototype: `domField item:domField`

* the implementation code:

  The code below is in domcom/src/dom-util.coffee:

	exports.domField = (value) ->

	  if !value? then return ''

	  if typeof value != 'function'

	   if value.then and x.catch
	     fn = react -> fn.promiseResult

	     value.then (value) ->
	        fn.promiseResult = value
	        fn.invalidate()

	     .catch (error) ->
	        fn.promiseResult = error
	        fn.invalidate()

	     return fn

	   else return value

	  if !value.invalidate then return renew(value)

	  value

##### domValue

  If the value is undefind or null, "" is returned; if the value is normal function, renew reactive function is returned; if the value is a reactive function, the value itself is returned; if the value is Promise (which has then method and catch method), a reactive function is returned to proxy the promise. In other cases the value itself is returned (because domField is used as Dom properties, so it will be converted to string by calling toString method because the feature of Javascript language itself).

  domValue is generally called by domcom automatically, the user does not need to call this method directly.

* function type

  > function prototype: `domValue item:domField`

* the implementation code:

  The code below is in domcom/src/dom-util.coffee:

    exports.domValue = (value) ->
      if !value? then return ''
      else if typeof value != 'function' then value
      else
        value = value()
        if !value? then return ''
        else value

##### requestAnimationFrame (i.e. dc.raf)

  window.requestAnimationFrame or its polyfill. This method is used by dc.renderLoop.

* function type

  > function prototype: `requestAnimationFrame callback:Callback`

* sample

 The code below is in domcom/src/dc.coffee:

	dc.renderLoop = renderLoop = ->
	  requestAnimFrame renderLoop
	  render()
	  return

*********************************************************

####  module: require('extend'): https://github.com/justmoon/node-extend

##### extend

  Augment the key/value in the first argument with the following arguments.

* module: domcom/src/extend

* function prototype

 > function prototype: ` extend toObject:Object, fromObjects:[Object]:...`

* sample

  The code below i sin domcom/src/index.coffee:

	extend dc,

	  require './config'

	  # utilities
	  require './flow/index'
	  require './flow/watch-list'
	  require './dom-util'
	  require './util'

	  # component
	  require './core/index'

### Domcom directives

 domcom let the code to be simpler and more readable by using directives in some cases. domcom directives is somewhat similar to angular.js directives, but with different semantics. In domcom the directives are just some syntax sugar, and they do not play some important role, and they can always can be replaced by normal function.

 The directives can only be used on Tag components. The method to use directive is like below:

   tag { ..., $directiveName: directiveArguments, ...}, ...

 While initializing Tag component and processing its attributes, domcom will treat the attribute leading by the "$" character as a directive, it will look up the registered directives to find one directive handler generator, call the generator with directiveArguments, and execute the returned directive handler on the component.

#### Regiester directive

  To use the directives in domcom, they must be regesited explicitly. There are two methods to register. The first one is to register directives batchly:

  > function prototype: `dc.directives {$directiveName:generator:DirectiveHandlerGenerator ... }`

  The second one is to register a single directive:

  > function prototype: `dc.directives $directiveName:String, generator:DirectiveHandlerGenerator`

  As above, DirectiveHandlerGenerator is the directive handler generator, which is a function to return a directive handler. Its type is like below:

  > function prototype: `DirectiveHandlerGenerator: (...) -> DirectiveHandler`

  DirectiveHandler is the directive handler generator, it receives the component as its argument, and it processes the component and returns the component itself. Its type is like below:

  > function prototype: `DirectiveHandler: (component) -> component`

#### builtin directives

  Domcom predifines some builtin directives.

##### subfolder: src/directives/

##### explanation

  Some  directives are defined in the folder above. They are just some functions, which can be used as directive handler generator, and can be registered as directives with the code below:

    dc.directives dc.builtinDirectives

  You can also register a single directive once, e.g.

    {$model} = dc
    dc.directives $model:$model

##### $model directive

* module: src/directives/model

* usage: tag $model: model

##### $bind directive

* module: src/directives/bind
* usage: tag $bind: model

##### $show and $hide directive

* module: src/directives/show-hide
* usage:
  tag $show:test
  tag $show: [test, display]
  tag $hide: test
  tag $hide: [test, display]

##### $splitter directive

* module: src/directives/splitter
* $splitter: direction

##### $options directive

* module: src/directives/options

* explanation: can only be used with `<select>` tag component

* usage: select $options: [items]

##### $blink usage

* module: src/directives/blink
* tag $blink: delay

#### sample

    {input, model, duplex} = require('domcom')
    obj = {a:1}
    a = duplex obj, 'a'
    comp = text type:'text', $model:a

***********************************************************

### builtin components

  Domcom predefined some builtin compnents, including combo, dialog, triangle, autoWidthEdit, accordion, etc. These components existed mainly to demonstrate extending domcom. From the samples we can find it is very simple to extend or combine the components under the domcom framework.

#### subfolder: domcom/src/builtins/
