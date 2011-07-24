#### Used in Windows to show the title and provide basic minimize, maximize, and close functionality
# *Important: This class will most likely inherit from Wiggy.ui.LayoutContainer
# or Wiggy.ui.Panel as soon as visual layouts are implemented.*
class Wiggy.ui.Titlebar extends Wiggy.ui.Widget
  constructor: (config) ->
    super config

    { @text } = config if config?

    @buttons = new Wiggy.ui.ButtonGroup
      minSelect: 0
      maxSelect: 0
      items: [
        { element: cssClass: 'minimize' }
        { element: cssClass: 'maximize' }
        { element: cssClass: 'close' }
      ]

    @title = new Wiggy.ui.Element
      cssClass: 'wiggy-title'
      html: @text

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    $titlebar = @element.dom
    @buttons.render $titlebar
    @title.render $titlebar

    # Shortcut to get panel styling on the titlebar. This will be corrected
    # once switched over to inheriting from panel
    $titlebar.addClass 'wiggy-panel wiggy-titlebar'
