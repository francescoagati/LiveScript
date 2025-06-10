macros = require '../lib/macros'
macros.define 'when', (test, ...body) ->
  macros.qq ['`', ['if', [',', test], [',@', body]]]
path = require 'path'
macro-path-ls = path.normalize 'test/data/macro-cli.ls'
macro-path-js = path.normalize 'test/data/macro-cli.js'

commandEq "--expand-macros -cb --debug --no-header #{macro-path-ls}", [
  "#macro-path-ls => #macro-path-js"
], ->
  try
    ok fileExists 'test/data/macro-cli.js'
    js = fileRead 'test/data/macro-cli.js'
    ok js.indexOf('macros.compile') is -1
    moduleObj = {exports: {}}
    Function('module', js) moduleObj
    eq moduleObj.exports.result, 1
  finally
    fileDelete 'test/data/macro-cli.js'


