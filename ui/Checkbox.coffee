#### Wrapper for prettier looking checkboxes
class Wiggy.ui.Checkbox extends Wiggy.ui.Field
  constructor: (config) ->
    config ?= {}
    config.element ?= {}
    config.element.nodeType ?= 'input'
    config.element.inputType ?= 'checkbox'

    super config

    { @checked } = config

    @button = new Wiggy.ui.Button
      element: cssClass: config.buttonClass or 'wiggy-checkbox'

  onShow: =>
    super()
    @button.show()

  onHide: =>
    super()
    @button.hide()

  onDisable: =>
    super()
    @button.disable()

  onEnable: =>
    super()
    @button.enable()

  onRender: (parent, idx) =>
    return @ if @rendered
    @button.render @element.parent

    super arguments...

    # We need to hide the default browser input checkbox and replace the
    # element's show function with one that does nothing. This ensures the
    # original checkbox wont become visible as this widget is shown/hidden
    @element.dom.show = ->
    $input = @element.dom.hide()

    @button.on 'click', =>
      $input.trigger 'click'

    $button = @button.element.dom
    $button.attr 'name', @name

    $label = @label.dom

    $label.mouseover =>
      return false if @disabled
      $button.addClass 'hover'
      $label.css 'cursor', 'pointer'

    $label.mouseout =>
      return false if @disabled
      $button.removeClass 'hover'
      $label.css 'cursor', 'default'

    $label.mousedown =>
      return false if @disabled
      $button.addClass 'active'

    $label.mouseup =>
      return false if @disabled
      $button.removeClass 'active'

    $input.click =>
      return false if @disabled
      if $button.hasClass 'checked'
        $button.removeClass 'checked'
      else
        $button.addClass 'checked'

    if @checked
      $input[0].checked = true
      $button.addClass 'checked'

    @button.disable() if @disabled
