#### Field used for search query inputs
class Wiggy.ui.Searchfield extends Wiggy.ui.Widget
  constructor: (config) ->
    super config

    @textfield = new Wiggy.ui.Textfield
      name: 'query'
      labelText: 'Search'
      # Trying to use the HTML 5 search control causes a nightmare of prestyled
      # CSS to show up, so commented out for now... thanks Chrome...
      #
      #     element: inputType: 'search'

    @button = new Wiggy.ui.Button
      element: cssClass: 'iconic magnifying-glass'

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    $search = @element.dom
    $search.addClass 'wiggy-searchfield'

    @textfield.render $search
    @button.render $search

    $btn = @button.element.dom
    $txt = @textfield.element.dom

    $btn.hover ( -> $txt.addClass 'hover' ),
               ( -> $txt.removeClass 'hover' )

    $txt.hover ( -> $btn.addClass 'hover' ),
               ( -> $btn.removeClass 'hover' )
    
    $btn.mousedown () -> $txt.addClass 'active'
    $btn.mouseup   () -> $txt.removeClass 'active'
    $txt.focusin   () -> $btn.addClass 'focus'
    $txt.focusout  () -> $btn.removeClass 'focus'
