#### Input field for large amounts of text
class Wiggy.ui.Textarea extends Wiggy.ui.Textfield
  constructor: (config) ->
    config ?= {}
    config.element ?= {}
    config.showLabel ?= false

    config.element.nodeType = 'textarea'

    super config

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    $textarea = @element.dom
    $textarea.addClass 'wiggy-textarea'
    $textarea.attr 'placeholder', @labelText unless @showLabel
