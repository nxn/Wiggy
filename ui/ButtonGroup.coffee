#### A group of related buttons with selection constraints
class Wiggy.ui.ButtonGroup extends Wiggy.ui.DynamicContainer
  # *NOTE: **_deselect** and **_select** are not methods, but they are invoked in the
  # context of this object via **Function.call**. (ie, a crummy way of making them
  # private)*
  _deselect = (btn, idx) ->
    return if @selected.length <= @minSelect

    btn.element.dom.removeClass 'active'
    @selected = (s for s in @selected when s isnt idx)
    
  _select = (btn, idx) ->
    return unless @maxSelect > 0

    if @selected.length >= @maxSelect
      i = @selected.shift()
      @items.get(i).element.dom.removeClass 'active'

    btn.element.dom.addClass 'active'
    @selected.push idx

  constructor: (config) ->
    # Default/overwrite the item types to **Wiggy.ui.Button** so that 1) the widget
    # setting is optional, and 2) this object only contains Button types (it's
    # called a **Button**Group for a reason)
    item.widget = Wiggy.ui.Button for item in config.items

    super config

    { @minSelect
      @maxSelect
      @selected
    } = config

    @minSelect ?= 0
    @maxSelect ?= 0
    @selected  ?= []

    # If there is to only be one pre-selected button in this group its index may
    # be specified by the **config** object without having to be wrapped in an
    # array. When that is the case, wrap it in an array now to avoid type
    # problems later on.
    if @selected not instanceof Array
      @selected = [ @selected ]

    # Whenever any of the buttons in the group are clicked, the **select** event
    # should fire.
    #
    # *NOTE: don't do this with the button's **handler** property since the user will
    # want that for their own button click logic.*
    @on 'select', @onSelect
    @items.each (btn, idx) =>
      btn.on 'click', => @select btn, idx

  onSelect: (btn, idx) =>
    if idx in @selected
      _deselect.call @, btn, idx
    else
      _select.call @, btn, idx

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    @element.dom.addClass 'wiggy-buttongroup'
    @items.each (btn, idx) =>
      btn.element.dom.addClass 'active' if idx in @selected
