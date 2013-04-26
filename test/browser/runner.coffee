"use strict"

_ = require("underscore")
ecstatic = require("ecstatic")
fs = require("fs")
glob = require("glob")
http = require("http")
path = require("path")
opener = require("opener")

libraryName = process.argv[2]
library = require("./libraries/#{ libraryName }")

testFilenames = glob.sync("../*.coffee", cwd: __dirname)
testScriptTags = testFilenames.map (filename) -> "<script type=\"text/coffeescript\" src=\"#{ filename }\"></script>"

htmlTemplate = fs.readFileSync(path.resolve(__dirname, "template.html")).toString()
html = _.template(htmlTemplate, { library, testScriptTags })

htmlPath = path.resolve(__dirname, "output.html")
fs.writeFileSync(htmlPath, html)

rootPath = path.resolve(__dirname, "../..")
relativePath = path.relative(rootPath, htmlPath).replace("\\", "/")

http.createServer(ecstatic(rootPath, cache: false)).listen(9835)

opener("http://localhost:9835/" + relativePath)
