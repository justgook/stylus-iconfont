#stylus iconfont

You love font icons - then try use it with **stylus-iconfont**

You hate font icons - that means that u haven't try **stylus-iconfont**

You love font-awesome - then try use it with **stylus-iconfont**

You hate font-awesome - u can use **stylus-iconfont** and bake own

Use font as plain svg, and let stylus care about rest

## Installation

```bash
$ npm install stylus-iconfont -g
```

##Usage

####Javascriot

```
var stylus = require('stylus'),
	stylusIconFont = require('stylus-iconfont'),
	fontFactory = new stylusIconFont()
stylus
.use(fontFactory.register) // collects glyph names, and register mixins
.render(str, { filename: 'nesting.css' }, function(err, css){
  if (err) throw err;
  console.log(css);
});
fontFactory.run() // build font from collected glyphs names

```

####Stylus
```
icon-font-font-face()

h1:before
  font-family: icon-font-name
  content: icon-font-unicode("close")
```

##Integration
 
 * [Gulp](https://github.com/justgook/stylus-iconfont/wiki/Gulp-integration)
 
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

#### options.autoDownloadVendor
Type: `Boolean`
Default value: `true`

Auto download vendor icon sets based on icon prefix

**VendorPrefixes:**

   * `fa` - [Font Awesome](http://fortawesome.github.io/Font-Awesome/)

**Example:**

```
icon-font-font-face()

.fa
  font-family: icon-font-name

.fa.fa-bicycle:before
  content: icon-font-unicode("fa/bicycle")
```
  
**Warning:** 
 
 * All vendor icons will be placed under `<glyphsDir>/download/<vendorPrefix>`
 * All downloads will start once option is **enabled**, and catch first `vendorPrefix` in some mixin
 * Downloader will download and parse **ALL** available icons in vendor set



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
Default value: `true`

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


##Versioning

Project will be maintained under the Semantic Versioning guidelines as much as possible. Releases will be numbered with the following format:
```
<major>.<minor>.<patch>
```

And constructed with the following guidelines:

Breaking backward compatibility bumps the major (and resets the minor and patch)
New additions,without breaking backward compatibility bumps the minor (and resets the patch)
Bug fixes and misc changes bumps the patch
For more information on SemVer, please visit http://semver.org.

