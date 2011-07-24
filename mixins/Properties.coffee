#### Mixin adds 'property' functionality to a constructor's propertype.
#
# *Mostly done for cross browser compatibility issues (not all supported browsers
# have Object.defineProperty).*
Wiggy.mixin.Properties = (() ->
  # Creates a property on the object whose context it is being executed under
  _property = (label, descriptor) ->
    if Object.defineProperty?
      Object.defineProperty @, label, descriptor
    else
      @.__defineGetter__ label, descriptor.get if descriptor?.get?
      @.__defineSetter__ label, descriptor.set if descriptor?.set?

  # Add the property function reference to the constructor's prototype object
  return (o) ->
    o::property = _property
    o
)()
