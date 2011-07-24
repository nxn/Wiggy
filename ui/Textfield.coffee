#### Input field for text
class Wiggy.ui.Textfield extends Wiggy.ui.Field
  constructor: (config) ->
    config ?= {}
    config.element ?= {}
    config.showLabel ?= false

    config.element.nodeType  ?= 'input'
    config.element.inputType ?= 'text'

    super config

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    $textfield = @element.dom
    $textfield.addClass 'wiggy-textfield'
    $textfield.attr 'placeholder', @labelText unless @showLabel
