#### Base class for Widgets
# *All widgets should inherit from this class to get basic functionality, events,
# and to be placed in the Widget Collection.*
class Wiggy.ui.Widget
  # Add event functions via Observable mixin
  Wiggy.mixin.Observable @
  
  # Stores a collection of all the objects that derive from this class for quick
  # ID based lookups
  @Collection: new Wiggy.data.Dictionary()

  constructor: (config) ->
    { @id
      @disabled
      @hidden
      @element
    } = config if config?

    @id        = Wiggy.generateId() unless @id?
    @rendered  = false
    @hidden   ?= false
    @disabled ?= false
    @element  ?= { }

    unless @element instanceof Wiggy.ui.Element
      @element = new Wiggy.ui.Element @element

    Wiggy.ui.Widget.Collection.add @id, @

    # Bind the basic event handlers to their respective events
    @on 'show',    @onShow
    @on 'hide',    @onHide
    @on 'enable',  @onEnable
    @on 'disable', @onDisable
    @on 'render',  @onRender
    @on 'dispose', @onDispose

  onDispose: =>
    @element.dom.remove() if @element.alreadyInDom
    delete @

  onRender: (parent, idx) =>
    # Make sure we never render more than once
    return if @rendered

    # If the widget is hidden, there is no reason to render it yet. When
    # **show** is dispatched that will cause the render event to occur then.
    return if @hidden

    # If this element already has a parent then it already belongs to the DOM
    # and we can leave this function now
    return @rendered = true if @element.alreadyInDom

    @element.dom.attr 'id', @id
    @element.render arguments...

    @rendered = true

    @disable() if @disabled

  onShow: =>
    @hidden = false
    @render() unless @rendered
    @element.dom.show()

  onHide: =>
    @hidden = true
    # No need to do anything to the DOM if this widget has not been rendered yet.
    return unless @rendered
    @element.dom.hide()
    @

  onDisable: =>
    # If this widget is not rendered already this handler will be called again
    # at the time that it is being rendered (**onRender** calls **disable()** when
    # the **@disabled** flag is set to true like it is now).
    @disabled = true

    # With that said, just return early for now to avoid doing unnecessary
    # dom manipulation.
    return @ unless @rendered
    @element.dom.attr 'disabled', true

  onEnable: =>
    @disabled = false
    # No need to do anything to the DOM if this widget has not been rendered yet.
    return @ unless @rendered
    @element.dom.removeAttr 'disabled'
