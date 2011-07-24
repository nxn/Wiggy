#### Wrapper for prettier looking Radiobuttons
class Wiggy.ui.Radiobutton extends Wiggy.ui.Checkbox
  constructor: (config) ->
    config ?= {}
    config.element ?= {}
    config.element.inputType ?= 'radio'
    config.buttonClass ?= 'wiggy-radiobutton'
    # A unicode value for a tick symbol, not used anymore
    #
    #     config.tickChar ?= '&#x2022;'

    super config

  onRender: (parent, idx) =>
    return @ if @rendered

    super arguments...

    @element.dom.click =>
      # Selects all radiobuttons that have the same name with the exception of
      # this one
      Wiggy.dom(".wiggy-radiobutton[name=\"#{ @name }\"]:not(input, ##{ @button.id })")
           .removeClass 'checked'
