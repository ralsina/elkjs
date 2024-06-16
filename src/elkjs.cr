# TODO: Write documentation for `Elkjs`
module Elkjs
  VERSION = "0.1.0"

  # TODO: Put your code here
end

@[Link(ldflags: "#{__DIR__}/elk.o")]
lib Elk
  type Js = Void*
  alias Jsval = LibC::UInt64T

  fun js_create(buffer : LibC::Char*, len : UInt32) : Js
  fun js_mkundef : Jsval
  fun js_glob(js : Js) : Jsval
  fun js_mkfun((Js, Jsval*, UInt32) -> Jsval) : Jsval
  fun js_set(js : Js, obj : Jsval, name : LibC::Char*, val : Jsval)
  fun js_eval(js : Js, code : LibC::Char*, len : UInt32) : Jsval
end

js_print = ->(js : Elk::Js, args : Elk::Jsval*, nargs : UInt32) : Elk::Jsval {
  # TODO: process args and do something
  p! "Print called with #{nargs} arguments"
  Elk.js_mkundef
}

js = Elk.js_create((" "*8192), 8192)
res = Elk.js_mkundef
Elk.js_set(js, Elk.js_glob(js), "print", Elk.js_mkfun(js_print))

code = "print('Hello, World!', 42);"
Elk.js_eval(js, code, code.bytesize)
