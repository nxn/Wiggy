#### Used for describing complex, but static, interfaces that are composed of multiple Widgets.
# *This is the Container type you want to use when you want to compose your
# widgets visually. If you want to create a dynamic interface, look at
# DynamicContainer. If you need the best of both worlds, remember that
# containers can be nested as needed.*
class Wiggy.ui.LayoutContainer extends Wiggy.ui.Widget
  constructor: (config) ->
    super config

    { items, @layout } = config if config?

    # Handle instantiating items for any item configs that were given
    items ?= {}
    @items = for own key, item of items
      items[key] = Wiggy.make item

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    for own key, item of @items
      if item instanceof Wiggy.ui.Widget or item instanceof Wiggy.ui.Element
        item.render @element.dom
