#### Wrapper for simple dom elements
# *The main difference from a Widget is that this does not implement the
# Observable mixin. The **render** and **dispose** methods are not dispatching
# any events, but they do allow Elements to be members of a Container.*
class Wiggy.ui.Element
  Wiggy.mixin.Properties @

  constructor: (config) ->
    { id
      nodeType
      inputType
      cssClass
      style
      html
    } = config if config?

    style    ?= {}
    nodeType ?= "div"
    html     ?= ""
    @parent   = config?.parent or document.body

    # The **dom** property only creates an actual HTML dom object when accessed the
    # first time. After that the reference to the already created one is
    # returned. This means that this class can be instantiated/disposed without
    # necessarily affecting the DOM.
    node = null
    @property 'dom', get: ->
      unless node?
        if nodeType.toLowerCase() is 'input'
          node = Wiggy.dom "<input />", type: inputType
        else
          node = Wiggy.dom "<#{ nodeType }></#{ nodeType }>"
        node.attr 'id', id if id?
        node.css key, val for own key, val of style
        node.html html
        node.addClass cssClass
      node

    # **dom** is a jQuery object, if we want the actual HTML dom object we can get
    # it by the **htmlObject** property.
    @property 'htmlObject', get: -> @dom[0]
    @property 'alreadyInDom', get: -> @dom.parent()?.length > 0

  setStyle: (style) -> dom.css key, val for own key, val of style

  render: (parent, idx) ->
    parent ?= @parent

    # The index where we will be inserting this dom object inside of the **parent**
    # element is optional. If we didn't get one, we just append this dom object
    # to the **parent**.
    unless idx?
      Wiggy.dom(parent).append @dom
      return @

    # Ensure **parent** is a jQuery object and not a simple HTML dom object by
    # checking that it has a **children** function.
    unless parent.children?
      parent = Wiggy.dom parent

    parent.children().eq(idx).before @dom

  dispose: -> @dom.remove()
