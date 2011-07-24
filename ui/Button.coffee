#### A clickable button widget
class Wiggy.ui.Button extends Wiggy.ui.Widget
  constructor: (config) ->
    # Default the element node type to **button**
    config ?= {}
    config.element ?= {}
    config.element.nodeType ?= "button"

    if config?.element?.nodeType is 'input'
      config.element.inputType = 'button'

    super config

    { @text, click } = config

    @text ?= ""
    @handler = click

    @on 'click', @onClick

  onClick: =>
    return false if @disabled
    @handler arguments... if @handler?
    
  setText: (@text) =>
    @element.dom.html @text

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    $button = @element.dom

    if @element.htmlObject.tagName is "INPUT"
      $button.attr 'value', @text
    else
      $button.html @text

    # Add listener to dom object that dispatches this object's **click** event which
    # in turn will invoke the **@handler** if the button isn't disabled.
    #
    # *NOTE: This is such a cheesy way of doing this -- think of something less
    # error prone*
    $button.click (e) => @click arguments...
    $button.addClass 'wiggy-button'
