# **An event driven HTML 5 user interface library with upcoming support for
# visual layouts.**
#
# *Copyright (c) 2011 Ernie Wieczorek*
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ***

#### A singleton for storing utility functions
Wiggy =
  format: (tpl, vals...) ->
    tpl.replace /{(\d)}/g, (match, group, idx, str) ->
      vals[group]

  generateId: ->
    gen = () -> 'wiggy-' + (Math.random() * 0x10000 | 0)

    # Generate a random **id**
    id = gen()

    # Should the **id** exist in the document, start generation loop until we get a
    # unique one
    id = gen() while document.getElementById id

    return id

  create: (obj) ->
    if obj instanceof Wiggy.ui.Widget
      # Given an instance of a Widget, return it
      return obj
    else if obj.hasOwnProperty 'widget'
      # Given a config, create an instance of the Widget
      return new obj.widget obj
    null

  # When the function receives multiple objects in the form of multiple
  # arguments or one or more arrays, it will return a Sequence of the
  # instantiated Widgets. If receiving a single widget config, it will return a
  # single instantiated Widget.
  #
  # Wrap arguments inside of an array, like the following line, when only a single
  # type of return value is desired:
  #
  #      Wiggy.make [ config ] 
  #
  # This forces the result to always be a **Wiggy.data.Sequence**
  make: (args...) ->
    if args.length is 1 and args[0] not instanceof Array
      return Wiggy.create args[0]

    results = new Wiggy.data.Sequence()

    addAsWidget = (item) ->
      widget = Wiggy.create item
      results.add widget if widget?

    for o in args
      if o instanceof Array
        addAsWidget item for item in o
      else
        addAsWidget o

    results

  register: (args...) ->
    for ns in args
      parent = window
      for pt in ns.match /([^.]+)/g
        parent[pt] = {} if not parent[pt]?
        parent = parent[pt]

  # Alias **jQuery** as Wiggy.**dom**
  dom: jQuery

# Coffeescript places all code in a function literal, so to expose the objects
# we need to assign it to **window**.
window.Wiggy = Wiggy

# *Also worth mentioning is that even if we do not assign the Wiggy singleton to
# window.Wiggy, the register function will still create the namespaces in
# window (they will not be available in this scope and things will break 
# immediately).*
Wiggy.register(
  'Wiggy.mixin'
  'Wiggy.util'
  'Wiggy.ui'
  'Wiggy.data'
  'Wiggy.themes'
)
