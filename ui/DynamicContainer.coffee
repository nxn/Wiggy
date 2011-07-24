#### Sequence of widgets and elements that can be modified at runtime regardless of whether container itself has already been rendered or not.
#
# *This is the container type you'd want to use when creating UIs that change based
# on events.*
class Wiggy.ui.DynamicContainer extends Wiggy.ui.Widget
  constructor: (config) ->
    super config

    { items } = config if config?
    items ?= []

    # handle instantiating items for any item configs that were given
    @items = Wiggy.make items

    @items.on 'add',    @onAdd
    @items.on 'set',    @onSet
    @items.on 'insert', @onInsert
    @items.on 'remove', @onRemove
    @items.on 'clear',  @onClear

    # NOTE: it probably isn't necessary to implment 'onDispose' in this class
    # since calling @element.dom.remove() automatically removes child elements
    # from the DOM and the GC should be able to collect everything in @items when
    # Wiggy.ui.Widget performs 'delete @' ... hopefully.


  make = (item) ->
    # If not all of the items we received are instances of supported types
    # chances are they are config objects. To handle this situation first the
    # event must be cancelled to prevent adding unsupported types to the @items
    # sequence. Then, an attempt is made to instantiate the config objects and
    # update the items array with the instances. Finally, if all goes well, we
    # re-dispatch the @items.add event with the now correct item types, allowing
    # them to be added to @items
    #
    # NOTE: Perhaps it would be cleaner to not cancel the event and instead find
    # some way to have a callback execute that will replace the configs in
    # @items with actual instances? Not sure...

    unless item instanceof Wiggy.ui.Widget or item instanceof Wiggy.ui.Element
      return [true, Wiggy.make item]

    return [false, item]
    
  onAdd: (items...) =>
    reset = false
    for item, idx in items
      [ _reset, items[idx] ] = make item
      # 'or=' performs a weak check for falsy values -- this will only assign to
      # 'reset' if it's not true already
      reset or= _reset

    if reset
      @items.add items...
      return false

    item.render @element.dom for item in items if @rendered

  onSet: (idx, item) =>
    # Keep @items Sequence dense:
    #
    # If the request is to set an idx after the last item of @items, we're
    # really only adding, so fire that event instead, and cancel this one.
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
    # Keep @items Sequence dense:
    #
    # If the request is to insert anywhere after the last index of @items, we're
    # really only adding, so fire that event instead, and cancel this one.
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

    # Each item must be rendered; in the case of a widget, calling 'render' will
    # dispatch the render event, where as with an 'element' it is a simple
    # function call.
    @items.each (item, idx) =>
      if item instanceof Wiggy.ui.Widget or item instanceof Wiggy.ui.Element
        item.render @element.dom
