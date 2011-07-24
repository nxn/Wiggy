#### A movable/floating widget that contains a Panel (@body) for storing other types of components.
class Wiggy.ui.Window extends Wiggy.ui.Widget
  # Since windows are generally not nested within another Widget or any
  # particular DOM element, it's helpful to have a way to be able to look them
  # up by ID instead (also used for tracking focus/z-index).
  @Collection: new Wiggy.data.Dictionary()

  @Metadata:
    active: null
    zIndexSeed: 10000
    zIndexIncrement: 1
    zIndexOffset: 0

  constructor: (config) ->
    super config

    { @x
      @y
      @width
      @height
      @modal
      @titlebar
      @body
    } = config if config?

    $document = Wiggy.dom document

    @modal     = off
    @titlebar ?= {}
    @width    ?= 480
    @height   ?= 320
    @x        ?= $document.width()/2 - (@width/2)
    @y        ?= $document.height()/2 - (@height/2)
    @body     ?= new Wiggy.ui.Panel()

    # If the **titlebar** is not initiated, pass its config to the constructor to
    # get a new instance
    unless @titlebar instanceof Wiggy.ui.Titlebar
      @titlebar = new Wiggy.ui.Titlebar @titlebar
    
    # We need these ids to figure out whether the **move** event should be aborted
    # if the click occurred in one of this titlebar's buttons.
    @titlebarButtonIds = @titlebar.buttons.items.each (btn) => btn.id

    unless @body instanceof Wiggy.ui.Panel
      @body = new Wiggy.ui.Panel @body

    Wiggy.ui.Window.Collection.add @id, @

  focus: =>
    m = Wiggy.ui.Window.Metadata
    c = Wiggy.ui.Window.Collection
    return @ if @ is m.active

    el = @element.htmlObject

    # We will have to decrement all zindexes higher than this one to fill the
    # void created by moving this one up
    oldZ = el.style.zIndex

    # Set to max value. Ignore the fact count is 1 based because the for loop
    # will decrement this anyway
    el.style.zIndex = m.zIndexSeed + (c.len * m.zIndexIncrement)

    Wiggy.ui.Window.Collection.each (win) ->
      s = win.element.htmlObject.style
      # If we iterate over a window whose zIndex is larger than the previous
      # zIndex of this window, we drop its zIndex by one step to fill the void
      # that was created when this window was moved to the top.
      s.zIndex -= m.zIndexIncrement if s.zIndex > oldZ

    m.active = @

  onRender: (parent, idx) =>
    return @ if @rendered
    super arguments...

    $win = @element.dom
    $win.addClass 'wiggy-window'
    $win.mousedown @focus
    $win.css 'top', @y + "px"
    $win.css 'left', @x + "px"

    @titlebar.render $win
    @titlebar.element.dom.mousedown @move

    @body.render $win

    $body = @body.element.dom
    $body.css 'width', @width
    $body.css 'height', @height

  move: (e) =>
    # If the click occurred on a button within the titlebar, ignore it -- not
    # something that should trigger a move
    return true if e.target.id in @titlebarButtonIds

    el = @element.htmlObject

    $win = Wiggy.dom window
    $doc = Wiggy.dom document

    x = e.clientX - el.offsetLeft
    y = e.clientY - el.offsetTop

    m = (e) =>
      el.style.left = (e.clientX - x) + "px"
      el.style.top = (e.clientY - y) + "px"

    s = (e) ->
      $win.unbind 'mousemove', m
      $doc.unbind 'mouseup', s

    $win.mousemove m
    $doc.mouseup s
    
    e.preventDefault()
    e.stopPropagation()
