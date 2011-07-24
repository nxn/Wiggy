fs = require 'fs'
{print} = require 'util'
{join} = require 'path'
{spawn, exec} = require 'child_process'

red    = '\033[1;31m'
green  = '\033[0;32m'
cyan   = '\033[0;36m'
yellow = '\033[0;33m'
reset  = '\033[0m'
error  = false
files  = [
  "Wiggy.coffee"
  "mixins/Observable.coffee"
  "mixins/Properties.coffee"
  "data/Dictionary.coffee"
  "data/Sequence.coffee"
  "ui/Element.coffee"
  "ui/Widget.coffee"
  "ui/DynamicContainer.coffee"
  "ui/LayoutContainer.coffee"
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

option '-o', '--output [FILE]', 'Output filename'
option '-m', '--minified',      'Minify the output'

task 'build', 'Build wiggy and tests suite', (options) ->
  print "#{yellow}[ Starting Build ]#{reset}\n"
  jobs = [ buildWiggy ]
  done = ->
    generateDocs files if jobs.length is 0
  while job = jobs.pop()
    job options, done

task 'watch', 'Watch for code changes and recompile library when they happen', (options) ->
  print "#{yellow}Prebuilding and watching files for changes ... #{reset}\n"

  # perform a build on startup
  buildWiggy options
  generateDocs files

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
  for file in files
    do (file) ->
      fs.watchFile file, (curr, prev) ->
        if curr.mtime.getTime() != prev.mtime.getTime()
          build file
          generateDocs [file]

generateDocs = ->
  print "| #{cyan}Updating Documentation ... #{reset}\n"
  exec 'docco ' + files.join(' ')
  
buildWiggy = (options, callback) ->
  filename = options.output or= 'wiggy.js'


  # setup output file and call the compile function -- will call attachDependencies
  # when compilation is done
  fs.open filename, 'w', 0666, (err, fd) ->
    exitWith err if err?
    # append deps to output file, position tells it where to start writing

    startCompile = (code, position) ->
      print "| #{cyan}Compiling#{reset} ... "
      compile ['-cs'], code, fd, position, (err, position) ->
        # Check error status before proceeding with dependencies
        if err?
          buildFailed err
          return

        fs.close fd
        buildSucceeded()
        callback() if callback?

    getCode = (position) ->
      # this has to be read synchronously since file order is significant when building
      print "\n| #{cyan}Loading Files:#{reset}\n"

      code = for f,i in files
        console.log "| - #{cyan}#{i+1}/#{files.length}#{reset} - #{f}"
        fs.readFileSync f

      startCompile code, position

    getDependencies fd, getCode


getDependencies = (fd, callback) ->
  # attaches js files from 'deps' dir
  fs.readdir 'deps', (err, files) ->
    return callback fd, callback unless files? and files.length > 0

    print "| #{cyan}Preparing dependencies#{reset} ... "
    jsFiles = (js for js in files when js.match /\.js$/)
    remaining = jsFiles.length
    for file in jsFiles
      p = join 'deps', file
      fs.readFile p, (err, data) ->
        exitWith err if err?
        # writes to position followed by compiler output
        # (don't want to overwrite data)
        fs.write fd, data, 0, data.length, 0, (err, written) ->
          exitWith err if err?
          callback written
        
compile = (args, code, fd, written, callback) ->
  coffee = spawn 'coffee', args

  # setup error handling
  error = null
  coffee.stderr.setEncoding 'utf8'
  coffee.stderr.on 'data', (data) -> error = data
  coffee.stdin.on 'error', (data) -> error = data

  # setup data output handling
  coffee.stdout.on 'data', (data) ->
    print "... "
    fs.write fd, data, 0, data.length, written
    written += data.length

  coffee.stdout.on 'end', ->
    # return number of bytes written so we know where to write when attaching
    # dependencies
    callback error, written

  # push data into coffee compiler
  if coffee.stdin.write(code.join "\n\n")
    print "... "
    coffee.stdin.end()
  else
    coffee.stdin.on 'drain', ->
      console.log "\n#{red}Kernel buffer was full, draining#{reset}"
      coffee.stdin.end()

buildFailed = (data) ->
  error = true
  print "\n#{red}[ Build Failed ]#{reset}\n#{data}\n"

buildSucceeded = ->
  error = false
  print "\n#{green}[ Build Successful ]#{reset}\n"

exitWith = (data) ->
  reportError data
  process.exit 1
