#stylus iconfont

stylus mixins to create font based on mixins

## Installation

```bash
$ npm install stylus-iconfont -g
```

##Usage

####Javascriot

```
var stylus = require('stylus');
stylus
.use(stylusIconFont())
.render(str, { filename: 'nesting.css' }, function(err, css){
  if (err) throw err;
  console.log(css);
});

```

####Stylus
```
icon-font-font-face()

h1:before
  font-family: icon-font-name
  content: icon-font-unicode("close")
```
## API

### stylusIconFont(options)

#### options.glyphsDir
Type: `String`
Default value: `process.cwd()`

Directory where will be searched for glips

#### options.outputDir
Type: `String`
Default value: `process.cwd()`

Place where will be created font files

#### options.fontFacePath
Type: `String`
Default value: `'/'`

Path that will be used in `icon-font-font-face()` mixin

#### options.fontName
Type: `String`
Default value: `'iconfont'`

The font family name you want.

#### options.fixedWidth
Type: `Boolean`
Default value: `false`

Creates a monospace font of the width of the largest input icon.

#### options.centerHorizontally
Type: `Boolean`
Default value: `false`

Calculate the bounds of a glyph and center it horizontally.

**Warning:** The bounds calculation is currently a naive implementation that
 may not work for some icons. We need to create a svg-pathdata-draw module on
 top of svg-pathdata to get the real bounds of the icon. It's in on the bottom
 of my to do, but feel free to work on it. Discuss it in the
 [related issue](https://github.com/nfroidure/svgicons2svgfont/issues/18).

#### options.normalize
Type: `Boolean`
Default value: `false`

Normalize icons by scaling them to the height of the highest icon.

#### options.fontHeight
Type: `Number`
Default value: `MAX(icons.height)`
The outputted font height  (defaults to the height of the highest input icon).

#### options.descent
Type: `Number`
Default value: `0`

The font descent. It is usefull to fix the font baseline yourself.

**Warning:**  The descent is a positive value!

The ascent formula is: ascent = fontHeight - descent.

#### options.log
Type: `Function`
Default value: `false`

Allows you to provide your own logging function. Set to `function(){}` to
 impeach logging.
  
#### options.watchMode
Type: `Boolean`
Default value: `true`

Recompile font only when count (new glyphs) is added

#### options.outputTypes

Type: `Array`
Default value: `['svg', 'ttf', 'eot', 'woff']` 