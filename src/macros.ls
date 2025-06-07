macroEnv = {}
ls = require './index'

define = (name, fn) ->
  macroEnv[name] = fn

evalLS = (code) ->
  js = ls.compile '(' + code + ')', bare: true
  js = js.replace /^\/\/.*\n/, '' .replace /;\s*$/, ''
  Function('macros', 'return (' + js + ')')(module.exports)

defineLS = (name, code) ->
  define name, evalLS code

isList = Array.isArray

gensym-counter = 0
gensym = (prefix='g$') ->
  gensym-counter := gensym-counter + 1
  prefix + gensym-counter

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
    throw new Error "no matching pattern for macro #{name}"

qq = (x) ->
  if isList x
    if x.length > 0
      if x[0] is 'unquote'
        x[1]
      else if x[0] is 'splice'
        {splice: true, value: qq x[1]}
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
      expand macroEnv[expr[0]].apply null, expr.slice 1
    else
      for i from 0 til expr.length
        expr[i] = expand expr[i]
      expr
  else
    expr

module.exports =
  define: define
  defineSyntax: defineSyntax
  expand: expand
  qq: qq
  evalLS: evalLS
  defineLS: defineLS
  gensym: gensym
