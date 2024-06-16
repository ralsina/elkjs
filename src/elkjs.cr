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
  fun js_glob(js : Js) : Jsval
  fun js_eval(js : Js, code : LibC::Char*, len : UInt32) : Jsval
  fun js_str(js : Js, val : Jsval) : LibC::Char*
  fun js_chkargs(args : Jsval*, nargs : UInt32, spec : LibC::Char*) : Bool
  fun js_truthy(js : Js, val : Jsval) : Bool
  fun js_setmaxcss(js : Js, maxcss : LibC::SizeT)
  fun js_setgct(js : Js, gct : LibC::SizeT)
  fun js_stats(
    js : Js,
    total : LibC::SizeT*,
    min : LibC::SizeT*,
    cstacksize : LibC::SizeT*
  )
  fun js_dump(js : Js)

  # Create JS values from C values
  fun js_mkundef : Jsval
  fun js_mknull : Jsval
  fun js_mktrue : Jsval
  fun js_mkfalse : Jsval
  fun js_mkstr(js : Js, value : Void*, size : LibC::SizeT) : Jsval
  fun js_mknum(js : Js, value : Float64) : Jsval
  fun js_mkerr(js : Js, format : LibC::Char*, ...) : Jsval
  fun js_mkfun((Js, Jsval*, UInt32) -> Jsval) : Jsval
  fun js_mkobj(js : Js) : Jsval
  fun js_set(js : Js, obj : Jsval, name : LibC::Char*, val : Jsval)

  # Extract C values from JS values
  enum JsTypes
    JS_UNDEF
    JS_NULL
    JS_TRUE
    JS_FALSE
    JS_STR
    JS_NUM
    JS_ERR
    JS_PRIV
  end
  fun js_type(val : Jsval) : UInt32
  fun js_getnum(val : Jsval) : Float64
  fun js_getbool(val : Jsval) : Bool
  fun js_getstr(js : Js, val : Jsval, len : LibC::SizeT*) : LibC::Char*
end

js_print = ->(js : Elk::Js, args : Elk::Jsval*, nargs : UInt32) : Elk::Jsval {
  p! Elk.js_chkargs(args, nargs, "sd")
  (0...nargs).each do |i|
    str = Elk.js_str(js, args[i])
    puts String.new(str)
  end
  Elk.js_dump(js)
  Elk.js_mkundef
}

js = Elk.js_create((" "*8192), 8192)
Elk.js_set(js, Elk.js_glob(js), "print", Elk.js_mkfun(js_print))

code = "print('Hello, World!', 42);"
Elk.js_eval(js, code, code.bytesize)
