#### A container for composing multiple sub-widgets into an interface
# *Important: Will use LayoutContainer for generating interface once
# implemented*
class Wiggy.ui.Panel extends Wiggy.ui.LayoutContainer
  constructor: (config) ->
    super config
    { @title, @plain } = config if config?
    @title ?= ""
    @plain ?= false

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    @element.dom.addClass 'wiggy-panel' unless @plain
