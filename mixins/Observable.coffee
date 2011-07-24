#### Mixin for adding register/unregister event functions to a constructor's prototype.
Wiggy.mixin.Observable = (() ->
  # Function used for registering handlers for an event name
  #
  # Defining the **on** function as **_on** gets around a crummy coffeescript
  # decision to make keywords like **on**, **yes**, **off**, and **no** reserved.
  _on = (event, funcs...) ->
    @events = {} unless @events?
    
    if @events.hasOwnProperty event
      # If we already registered this event name, add the passed handlers to the
      # list of existing handlers
      @events[event].push func for func in funcs
    else
      # Create a property in the events object named after this event and assign
      # the given handlers to it
      @events[event] = funcs

      # This check's the type's prototype object to see if it has a function for
      # dispatching the just registered event type. In all likelyness it doesn't
      # since the event would have already been already registered if it did.
      # Either way, checking is good.
      unless @constructor::.hasOwnProperty event

        # Assign the dispatch method on the object's prototype that registered
        # this method. This essentially means that doing:
        #
        #     obj.on 'eventName', onEventHandler
        #
        # Will create a method 'eventName' on obj's prototype  that will
        # dispatch the event and invoke all the registered handlers. Ex:
        #
        #     obj.eventName()
        #
        @constructor::[event] = ->
          _dispatch.call(@, event, arguments)
          @
    @

  # Unregister a handler from an event name
  _un = (event, handler) ->
    # If we have no events dictionary or this event isn't in it, return
    return @ unless @events? and @events.hasOwnProperty event

    e = @events[event]
    # Splice the handler out of the events array
    for func, idx in e when func is handler
      e.splice idx, 1
    @

  # Logic for dispatching an event. There is no way to call this function
  # directly since the only reference to it will be created when an event is
  # registered. This will be done by wrapping it in another function named after
  # the event. See the definition of **_on** for more details on this.
  _dispatch = (event, params) ->
    # If we have no events dictionary or this event isn't in it, return
    return unless @events? and @events.hasOwnProperty event

    # Handlers must be invoked in reverse order due to being more specific to
    # the event and having ability to cancel more generic handlers that were
    # added first
    handlers = @events[event]
    for i in [(handlers.length-1) .. 0]
      break if handlers[i](params...) is false

  # When called, it will add function references for registering and unregistering
  # events onto the received constructor's prototype.
  return (o) ->
    o::on = _on # 9_9
    o::un = _un
    o
)()
