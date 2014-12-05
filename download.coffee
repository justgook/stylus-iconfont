svgfont2svgicons = require 'svgfont2svgicons'
yaml = require 'js-yaml'
fs = require 'fs'
http = require 'https'
ProgressBar = require 'progress'
Q = require 'q'
mkdirp = require 'mkdirp'

FontAwesome = (outputDir)->
  deferred = Q.defer()
  # deferred.resolve()
  iconProvider = svgfont2svgicons()
  iconsYAMLUrl = "https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/src/icons.yml"
  svgFontUrl = "https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/fonts/fontawesome-webfont.svg"
  mkdirp outputDir
  namesObject = []
  iconProvider.on 'end', ->
    setTimeout ->
      deferred.resolve()
    ,1000


  iconProvider.on 'readable', ->
    icon = iconProvider.read()
    if icon
      iconUnicode = icon.codepoint.charCodeAt(0).toString(16)
      name = ""
      (name = item.id; break) for item in namesObject when item.unicode is iconUnicode
      if name
        icon.stream.pipe(fs.createWriteStream("#{outputDir}/#{name}.svg"))
        # console.log('New icon:', icon.name, name);

  requestFont = -> http.get svgFontUrl, (response)->
    bar = new ProgressBar '[icon-font]: [:bar] :percent :etas Font-Awesome SVG extracting',
      complete: '=',
      incomplete: ' ',
      width: 25,
      total: parseInt response.headers['content-length']

    response.pipe iconProvider
    response.on 'data', (chunk)->
      bar.tick chunk.length
    # response.on 'end', ->
    #   deferred.resolve()
    #   return

  # get YAML file (for names)
  http.get iconsYAMLUrl, (response)->
    str = ""
    bar = new ProgressBar '[icon-font]: [:bar] :percent :etas Downloading Font-Awesome name file',
        complete: '=',
        incomplete: ' ',
        width: 25,
        total: parseInt response.headers['content-length']
    response.on 'data', (chunk)->
      str += chunk
      bar.tick chunk.length
    response.on 'end', ()->
      namesObject = (yaml.load str).icons
      requestFont()
    return
  return deferred.promise


module.exports = (prefix, outputDir)->
  # console.log "downloader"
  switch prefix
    when 'fa' then FontAwesome outputDir
  #
