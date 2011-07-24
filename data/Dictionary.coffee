#### An evented associative array.
# *Wraps a new javascript object with added functionality for events and 
# other conveniance functions (has, each, etc)*
class Wiggy.data.Dictionary
  Wiggy.mixin.Observable @
  Wiggy.mixin.Properties @

  constructor: ->
    @items = {}

    length = 0
    @property 'length',
      get: -> length
      set: (val) -> length = val

    @property 'isEmpty', get: -> @length is 0

    @on 'add',      @onAdd
    @on 'set',      @onSet
    @on 'addMany',  @onAddMany
    @on 'remove',   @onRemove
    @on 'clear',    @onClear

  has: (key) -> @items.hasOwnProperty key

  get: (key) -> @items[key]

  onAdd: (key, val) =>
    # if the key is not in all increment the len, otherwise we're just
    # settings an existing key to a new value (len stays the same)
    @length++ unless @has key
    @items[key] = val

  onAddMany: (items...) =>
    for item in items
      [key, val] = item
      @add key, val

  onSet: (key, val) =>
    if @has key
      @items[key] = val
    else
      @add key, val

  onRemove: (keys...) =>
    for k in keys when @has k
      delete @items[k]
      @length--

  onClear: =>
    @items = {}
    @length = 0

  each: (func) -> func val, key for own key, val of @items
