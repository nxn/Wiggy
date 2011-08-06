require.paths.push '/usr/local/lib/node_modules'

fs            = require 'fs'
{print}       = require 'util'
{join}        = require 'path'
{spawn, exec} = require 'child_process'
{Parser}      = require 'jison'

red     = '\033[1;31m'
green   = '\033[0;32m'
cyan    = '\033[0;36m'
yellow  = '\033[0;33m'
reset   = '\033[0m'
error   = false
grammar = 'bp/Blueprint.jison'
files   = [
  "Wiggy.coffee"
  "mixins/Observable.coffee"
  "mixins/Properties.coffee"
  "data/Dictionary.coffee"
  "data/Sequence.coffee"
  "ui/Element.coffee"
  "ui/Widget.coffee"
  "ui/DynamicContainer.coffee"
  "ui/BlueprintContainer.coffee"
  "ui/Button.coffee"
  "ui/ButtonGroup.coffee"
  "ui/Panel.coffee"
  "ui/TabPanel.coffee"
  "ui/Titlebar.coffee"
  "ui/Window.coffee"
  "ui/Field.coffee"
  "ui/Textfield.coffee"
  "ui/Textarea.coffee"
  "ui/Searchfield.coffee"
  "ui/Checkbox.coffee"
  "ui/Radiobutton.coffee"
]

# in the event minification is requested, these are the closure compiler
# settings we'll need to use
closureOptimization = "SIMPLE_OPTIMIZATIONS"
closureOutputFormat = "text"
closureOutputInfo   = "compiled_code"

option '-o', '--output [FILE]', 'Output filename'
option '-m', '--minified',      'Minify the output'

task 'build', 'Build wiggy and tests suite', (options) ->
  print "#{yellow}[ Starting Build ]#{reset}\n"
  buildWiggy options

task 'watch', 'Watch for code changes and recompile library when they happen', (options) ->
  print "#{yellow}Prebuilding and watching files for changes ... #{reset}\n"

  # perform a build on startup
  buildWiggy options

  build = (modifiedFile) ->
    # reset the error status each time before building
    error = false
    getTime = ->
      # prepend 0 to single digit numbers
      format = (n) -> if n < 10 then "0" + n else n
      d = new Date()
      "#{ format d.getHours() }:#{ format d.getMinutes() }:#{ format d.getSeconds() }"

    print "#{yellow}"
    print "\n#{getTime()}: File \"#{modifiedFile}\" modified.\n"
    print "#{reset}"
    buildWiggy options

  # attach listeners for all files to track changes and bind to builds
  watch = (file) ->
    fs.watchFile file, (curr, prev) ->
      if curr.mtime.getTime() != prev.mtime.getTime()
        build file

  watch file for file in files
  watch grammar

buildWiggy = (options, cb) ->
  filename = options.output or= 'wiggy.js'

  ws = fs.createWriteStream filename
  writeDependencies ws, ->
    compile ws, ->
      generateBlueprintParser ws, ->
        ws.end()

        m = (cb) ->
          minify options, cb

        sync m, generateDocs, buildSucceeded

writeDependencies = (ws, cb) ->
  deps = fs.readdirSync 'deps'
  return unless deps? and deps.length > 0

  print "| #{cyan}Attaching Dependencies ... #{reset}"
  jsFiles = (js for js in deps when js.match /\.js$/)
  remaining = jsFiles.length

  for file in jsFiles
    p = join 'deps', file
    rs = fs.createReadStream p
    rs.on 'close', ->
      if --remaining is 0
        print "#{green}DONE#{reset}\n"
        cb() if cb?

    rs.pipe ws, end: false

compile = (ws, cb) ->
  print "| #{cyan}Compiling Files:#{reset}\n"
  coffee = spawn 'coffee', ['-cs']

  coffee.stdin.setMaxListeners files.length

  coffee.stdout.pipe ws, end: false
  coffee.stdout.on 'end', ->
    print "| #{cyan}Compiling ... #{green}DONE#{reset}\n"
    cb() if cb?

  for f,i in files
    console.log "| - #{cyan}#{i+1}/#{files.length}#{reset} - #{f}"
    rs = fs.createReadStream f
    rs.pipe coffee.stdin

generateBlueprintParser = (ws, cb) ->
  print "| #{cyan}Creating Blueprint Parser ... #{reset}"
  fs.readFile grammar, 'utf8', (err, data) ->
    exitWith err if err?
    parser  = new Parser data
    src     = parser.generate moduleName: 'Wiggy.bp.Parser'
    written = ws.write src, 'utf8'
    done    = ->
      print "#{green}DONE#{reset}\n"
      cb() if cb?

    if written then done() else ws.on 'drain', done

generateDocs = (cb) ->
  print "| #{cyan}Updating Documentation ... #{reset}\n"
  exec 'docco ' + files.join(' '), ->
    cb() if cb?

minify = (opts, cb) ->
  unless opts.minified
    cb() if cb?
    return

  { parser, uglify } = require("uglify-js")

  print "| #{cyan}Minifying ... #{reset}\n"
  fs.readFile opts.output, 'utf8', (err, data) ->
    exitWith err if err?
    code = uglify.gen_code uglify.ast_squeeze uglify.ast_mangle parser.parse data
    fs.writeFile opts.output, code, 'utf8', ->
      cb() if cb?

sync = (fns..., cb) ->
  remaining = fns.length
  for fn in fns
    fn -> cb() if --remaining is 0 and cb

buildFailed = (data) ->
  error = true
  print "#{red}[ Build Failed ]#{reset}\n#{data}\n"

buildSucceeded = ->
  error = false
  print "#{green}[ Build Successful ]#{reset}\n"

exitWith = (data) ->
  buildFailed data
  process.exit 1
