es6 = ->
  LiveScript.compile it, {'es6-class': true, bare: true, header: false}

code = """
class Foo
  (@x) ->
  inc: -> @x += 1
  get: -> @x
"""
js = es6 code
ok /^class Foo/.test js
ok /constructor\(x\)/.test js
ok /this\.x = x/.test js
ok /inc\(/.test js
ok /this\.x \+= 1/.test js
ok /get\(/.test js
ok /return this\.x/.test js

Foo = new Function(js + '; return Foo')()
f = new Foo 3
eq f.get!, 3
eq f.inc!, 4
eq f.get!, 4
