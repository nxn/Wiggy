#### Contains a collection of Panels, displayed one at a time
class Wiggy.ui.TabPanel extends Wiggy.ui.DynamicContainer
  constructor: (config) ->
    # Set the item types to **Wiggy.ui.Panel**, and hide them by default
    for item, idx in config.items
      item.widget   = Wiggy.ui.Panel
      item.element ?= { }
      item.element.style = 'display': 'none'

    super config

    { @active } = config
    @active ?= 0

    @tabButtons = new Wiggy.ui.ButtonGroup
      items: @items.each (pnl, idx) -> text: pnl.title
      selected: @active
      minSelect: 1
      maxSelect: 1

    @on 'switch', @onSwitch
    @tabButtons.on 'select', (btn, idx) => @switch idx

  onSwitch: (idx) =>
    return false if idx is @active

    @items.get(@active).hide()
    @items.get(idx).show()

    @active = idx

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    @element.dom.addClass 'wiggy-tabpanel'

    @tabButtons.render @element.dom

    @items.get(@active).show()
