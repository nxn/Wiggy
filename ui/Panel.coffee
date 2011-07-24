#### A container for composing multiple sub-widgets into an interface
# *Important: Will use BlueprintContainer for generating interface once
# implemented*
class Wiggy.ui.Panel extends Wiggy.ui.BlueprintContainer
  constructor: (config) ->
    super config
    { @title, @plain } = config if config?
    @title ?= ""
    @plain ?= false

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    @element.dom.addClass 'wiggy-panel' unless @plain
