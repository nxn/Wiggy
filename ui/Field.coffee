#### Base class for form fields
# *Important: @label will be refactored to be its own widget type. Substantial
# changes will be made here*
class Wiggy.ui.Field extends Wiggy.ui.Widget
  constructor: (config) ->
    super config
    { @name
      @value
      @showLabel
    } = config if config?

    @showLabel ?= true

    @label = new Wiggy.ui.Element
      nodeType: "label"
      cssClass: 'wiggy-label'
    @label.dom.attr 'for', @id

    @setLabelText config.labelText if config?.labelText?

  setLabelText: (@labelText) ->
    @label.dom.html @labelText
    @

  onShow: =>
    super()
    @label.dom.show if @showLabel

  onHide: =>
    super()
    @label.dom.hide()

  onDisable: =>
    super()
    @label.dom.css 'color', '#999'

  onEnable: =>
    super()
    @label.dom.css 'color', '#000'

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    $field = @element.dom
    $field.attr 'name',  @name  if @name?
    $field.attr 'value', @value if @value?

    $field.before @label.dom if @showLabel
    @label.dom.css 'color', '#999' if @disabled
