macroEnv = {}
ls = require './index'
fs = require 'fs'

define = (name, fn) ->
  macroEnv[name] = fn

evalLS = (code) ->
  js = ls.compile '(' + code + ')', bare: true
  js = js.replace /^\/\/.*\n/, '' .replace /;\s*$/, ''
  Function('macros', 'return (' + js + ')')(module.exports)

defineLS = (name, code) ->
  define name, evalLS code

load-file = (filename) ->
  Module = require 'module'
  path = require 'path'
  code = fs.read-file-sync filename, 'utf8'
  js = ls.compile code, bare: true
  js = js.replace /^\/\/.*\n/, '' .replace /;\s*$/, ''
  mod = new Module filename, module
  mod.filename = filename
  mod.paths = Module._nodeModulePaths path.dirname filename
  mod._compile js, filename

isList = Array.isArray

# track lexical scopes for hygienic identifiers
scope-stack = [0]

gensym-counter = 0

with-scope = (fn) ->
  scope-id = scope-stack.length
  scope-stack.push scope-id
  try
    fn!
  finally
    scope-stack.pop!

gensym = (prefix='g$') ->
  gensym-counter := gensym-counter + 1
  prefix + (scope-stack.join '$') + '$' + gensym-counter

matchPattern = (pattern, expr, env = {}) ->
  if typeof pattern is 'string'
    if /^@[\w-]+\.\.\.$/.test pattern
      env[pattern.slice 1, -3] = expr
      true
    else if /^@[\w-]+$/.test pattern
      env[pattern.slice 1] = expr
      true
    else
      pattern is expr
  else if isList pattern and isList expr
    n = pattern.length
    if n > 0 and typeof pattern[n - 1] is 'string' and /^@[\w-]+\.\.\.$/.test pattern[n - 1]
      restName = pattern[n - 1].slice 1, -3
      return false if expr.length < n - 1
      for i from 0 til n - 1
        return false unless matchPattern pattern[i], expr[i], env
      env[restName] = expr.slice n - 1
      true
    else if expr.length is n
      for i from 0 til n - 1
        return false unless matchPattern pattern[i], expr[i], env
      true
    else
      false
  else
    pattern is expr

substitute = (template, env) ->
  if typeof template is 'string'
    if /^@[\w-]+$/.test template
      env[template.slice 1]
    else
      template
  else if isList template
    res = []
    for item in template
      if typeof item is 'string' and /^@[\w-]+\.\.\.$/.test item
        val = env[item.slice 1, -3] or []
        res = res.concat val
      else
        res.push substitute item, env
    res
  else
    template

defineSyntax = (name, patterns) ->
  define name, ->
    expr = [name] ++ Array.prototype.slice.call arguments
    for [pat, templ] in patterns
      env = {}
      return substitute templ, env if matchPattern pat, expr, env
    pat-str = patterns.map((p) -> JSON.stringify p[0]).join ', '
    throw new Error "no matching pattern for macro #{name}; tried #{pat-str}"

qq = (x) ->
  if isList x
    if x.length > 0
      if x[0] in ['unquote', ',']
        x[1]
      else if x[0] in ['splice', ',@']
        {splice: true, value: qq x[1]}
      else if x[0] is '`'
        qq x[1]
      else
        res = []
        for item in x
          val = qq item
          if val? and typeof val is 'object' and val.splice is true
            res = res.concat val.value
          else
            res.push val
        res
    else
      []
  else
    x

expand = (expr) ->
  if isList expr
    if typeof expr[0] is 'string' and Object.hasOwnProperty.call macroEnv, expr[0]
      with-scope ->
        expand macroEnv[expr[0]].apply null, expr.slice 1
    else
      for i from 0 til expr.length
        expr[i] = expand expr[i]
      expr
  else
    expr

to-js = (expr) ->
  if typeof expr is 'string'
    if /^[A-Za-z_$][\w$.]*$/.test expr
      expr
    else
      JSON.stringify expr
  else if isList expr
    switch expr[0]
      | 'if'
        cond = to-js expr[1]
        cons = to-js expr[2]
        if expr.length > 3
          alt = to-js expr[3]
          "if (#{cond}) {#{cons}} else {#{alt}}"
        else
          "if (#{cond}) {#{cons}}"
      | 'not'
        "!(#{to-js expr[1]})"
      | 'set'
        "#{to-js expr[1]} = #{to-js expr[2]}"
      | 'var'
        "var #{to-js expr[1]} = #{to-js expr[2]}"
      | 'do'
        expr.slice(1).map((e) -> to-js e).join('; ')
      | _
        "#{to-js expr[0]}(#{expr.slice(1).map((e) -> to-js e).join ', '})"
  else
    JSON.stringify expr

compile = (expr) ->
  to-js expand expr

preprocess = (code) ->
  out = ''
  i = 0
  while (j = code.index-of 'macros.compile', i) > -1
    out += code.slice i, j
    j += 'macros.compile'.length
    while /\s/.test code[j]
      j++
    if code[j] in '(['
      open = code[j]
      close = if open is '(' then ')' else ']'
      j++
      start = j
      depth = 1
      while depth > 0 and j < code.length
        ch = code[j]
        depth++ if ch is open
        depth-- if ch is close
        j++
      expr = code.slice start, j - 1
      js-expr = eval '(' + expr + ')'
      out += compile js-expr
      i = j
    else
      out += 'macros.compile'
      i = j
  out += code.slice i
  out


module.exports =
  define: define
  defineSyntax: defineSyntax
  expand: expand
  qq: qq
  evalLS: evalLS
  defineLS: defineLS
  loadFile: load-file
  gensym: gensym
  withScope: with-scope
  compile: compile
  preprocess: preprocess
