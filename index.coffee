stylus = require 'stylus'
path = require 'path'
fs = require 'fs'
svgicons2svgfont = require 'svgicons2svgfont'
svg2ttf = require 'svg2ttf'
ttf2eot = require 'ttf2eot'
ttf2woff = require 'ttf2woff'
nodes = stylus.nodes
utils = stylus.utils

# appDir = path.dirname require.main.filename

startIndex = 0xF700
glyphsHash = []

wrtiteToFile = (options)->
  result = ({codepoint: startIndex + index, name: glyph, stream: fs.createReadStream "#{options.glyphsDir}/#{glyph}.svg" } for glyph, index in glyphsHash)
  outputFile = "#{options.outputDir.replace /\/$/, ''}/#{options.fontName}"
  fontStream = svgicons2svgfont result, options
    .pipe fs.createWriteStream "#{outputFile}.svg"
    .on 'finish', ->
      ttf = svg2ttf fs.readFileSync("#{outputFile}.svg",encoding:"utf8"), {}
      ttfBuffer = new Buffer ttf.buffer
      fs.writeFileSync "#{outputFile}.ttf", ttfBuffer
      console.log "ttf font file created"
      try
        eot = ttf2eot(new Uint8Array(ttfBuffer))
        eotBuffer = new Buffer eot.buffer
        fs.writeFileSync "#{outputFile}.eot", eotBuffer
        console.log "eot font file created"
      catch err
        console.error err

      try
        woff = ttf2woff(new Uint8Array(ttfBuffer))
        woffBuffer = new Buffer woff.buffer
        fs.writeFileSync "#{outputFile}.woff", woffBuffer
        console.log "woff font file created"
      catch err
        console.error err

      console.log('Font written !')


unicode = (options)->
  (a)->
    index = glyphsHash.indexOf a.string
    if index < 0
      index = glyphsHash.push a.string
    new nodes.Literal """#{a.quote}\\#{(startIndex + glyphsHash.indexOf a.string).toString(16)}#{a.quote}"""

fontFace = (options)->
  pathToFont = "#{options.fontFacePath.replace /\/$/, ''}/#{options.fontName}"
  ->
    new nodes.Literal """
      @font-face {
        font-family: '#{options.fontName}';
        src: url('#{pathToFont}.eot?v=4.2.0');
        src: url('#{pathToFont}.eot?#iefix&v=4.2.0') format('embedded-opentype'), url('#{pathToFont}.woff?v=4.2.0') format('woff'), url('#{pathToFont}.ttf?v=4.2.0') format('truetype'), url('#{pathToFont}.svg?v=4.2.0#fontawesomeregular') format('svg');
        font-weight: normal;
        font-style: normal;
      }
      """
module.exports = (options)->
  options = options or {}
  ###
     svgicons2svgfont(options)
  ###
  options.fontName ?= 'iconfont'
  options.fixedWidth ?= false
  options.centerHorizontally ?= false
  options.normalize ?= false
  # options.fontHeight = Default value: MAX(icons.height)
  options.descent ?= 0
  options.log ?= false
  ###
     iconFont(options)
  ###
  #TODO find better solution
  options.glyphsDir ?= process.cwd()
  options.outputDir ?= process.cwd()
  options.fontFacePath ?= "/" #path that will be add to fontFace declaration
  return (style)->
    console.log "icon-font plugin enabled"
    style.set 'icon-font-filename', "#{options.fontFacePath.replace /\/$/, ''}/#{options.fontName}"
    style.define 'icon-font-unicode', unicode options
    style.define 'icon-font-font-face', fontFace options
    style.include __dirname
    this.on 'end', ->
      wrtiteToFile options
      return

module.exports.version = require(path.join(__dirname, 'package.json')).version
module.exports.path = __dirname




