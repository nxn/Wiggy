#### An evented array.
# *Wraps a javascript array with extra functionality for handling events and other conveniance
# functions.*
class Wiggy.data.Sequence
  Wiggy.mixin.Observable @
  Wiggy.mixin.Properties @

  constructor: (items) ->
    @items = items or []
    @property 'length', get: -> @items.length
    @property 'isEmpty', get: -> @length is 0
    @property 'unique', get: ->
      result = new Wiggy.data.Sequence()
      values = {}

      for val in @items
        type = typeof val
        if type is "string" or type is "number" or type is "boolean" or type is "undefined"
          # Since every value gets turned into a string when being set as a property
          # name, we must specify its initial type. This avoids the string value
          # **"false"** from being considered the same as the boolean value **false**
          values[type+val] = val

        else
          # In the event of reference types, the only way to check if we already
          # have that reference is to loop through all the ones that were found so
          # far. Since value types are going to their own temporary object, we can
          # use **result** exclusively for refs right now.
          result.add val unless val in result.items

      # Now that we've gone through all **@items**, we add the value types to the
      # result sequence and return it.
      result.add (val for key, val of values)

    @on 'add',    @onAdd
    @on 'set',    @onSet
    @on 'insert', @onInsert
    @on 'remove', @onRemove
    @on 'clear',  @onClear

  has: (val) -> val in @items

  get: (idx) -> @items[idx]

  onSet: (idx, val) =>
    @items[idx] = val

  onAdd: (items...) =>
    for item in items
      @items.push item

  onInsert: (idx, val) =>
    @items.splice idx, 0, val

  onRemove: (idxs...) =>
    # Sort indexes by descending order to ensure we don't offset items
    # located before our next deletion index
    idxs = idxs.sort (a,b) -> b - a
    for i in idxs
      @items.splice i, 1

  onClear: => @items = []

  sort: (func) -> @items.sort func

  each: (func) -> (func val, idx for val, idx in @items)
