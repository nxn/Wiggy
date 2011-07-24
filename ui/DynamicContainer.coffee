#### Sequence of widgets and elements that can be modified at runtime regardless of whether container itself has already been rendered or not.
#
# *This is the container type you'd want to use when creating UIs that change based
# on events.*
class Wiggy.ui.DynamicContainer extends Wiggy.ui.Widget
  constructor: (config) ->
    super config

    { items } = config if config?
    items ?= []

    # Instantiate **items** for any item configs that were given
    @items = Wiggy.make items

    # *NOTE: it probably isn't necessary to implment **onDispose** in this class
    # since by calling the following from **Wiggy.ui.Widget's onDispose**:*
    #
    #       @element.dom.remove()
    #       delete @
    #
    # *should automatically remove child elements from the DOM and the GC should be
    # able to collect everything in **@items**... hopefully.*
    @items.on 'add',    @onAdd
    @items.on 'set',    @onSet
    @items.on 'insert', @onInsert
    @items.on 'remove', @onRemove
    @items.on 'clear',  @onClear

  make = (item) ->
    # If the **item** we received is not an instance of a supported type (either
    # **Wiggy.ui.Widget** or **Wiggy.ui.Element**) chances are that it is a config
    # object. To handle this situation the item is passed over to **Wiggy.make**
    # to give us back an instance of a **Widget** or **Element**.
    #
    # However, we must also return a **reset** flag set to **true** to inform the
    # caller that it should cancel the event that got us here because the event's
    # arguments have non-instantiated widget configs that would be added to the
    # **@items** Sequence. This is something we want to avoid, therefore the
    # event will be cancelled and re-dispatched once all configs are instantiated.
    #
    # *NOTE: Perhaps it would be cleaner to not cancel the event and instead find
    # some way to have a callback execute that will replace the configs in
    # **@items** with actual instances? Not sure...*
    unless item instanceof Wiggy.ui.Widget or item instanceof Wiggy.ui.Element
      return [true, Wiggy.make item]

    return [false, item]
    
  onAdd: (items...) =>
    reset = false
    for item, idx in items
      [ _reset, items[idx] ] = make item
      # **or=** performs a weak check for falsy values -- this will only assign to
      # **reset** if it's not true already
      reset or= _reset

    if reset
      @items.add items...
      return false

    item.render @element.dom for item in items if @rendered

  onSet: (idx, item) =>
    # Keep **@items** Sequence dense:
    #
    # If the request is to set an index after **@items**'s last index we're really only
    # adding -- so fire that event instead, and cancel this one.
    if idx >= @items.length
      @items.add item
      return false

    [ reset, item ] = make item
    
    if reset
      @items.set idx, item
      return false

    item.render @element.dom, idx if @rendered
    @items.get(idx).dispose()

  onInsert: (idx, item) =>
    # Keep **@items** Sequence dense:
    #
    # If the request is to insert anywhere after the last index of **@items**, we're
    # really only adding -- so fire that event instead, and cancel this one.
    if idx >= @items.length
      @items.add item
      return false

    [ reset, item ] = make item
    
    if reset
      @items.insert idx, item
      return false

    item.render @element.dom, idx if @rendered
    
  onRemove: (idxs...) =>
    for idx in idxs
      item = @items.get idx
      item.dispose()
    
  onClear: => item.dispose() for item in @items

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    # Each item must be rendered; in the case of a widget, calling **render** will
    # dispatch the render event, where as with an element, it is just a simple
    # function call.
    @items.each (item, idx) =>
      if item instanceof Wiggy.ui.Widget or item instanceof Wiggy.ui.Element
        item.render @element.dom
