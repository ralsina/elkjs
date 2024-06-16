# TODO: Write documentation for `Elkjs`

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

module Js
  VERSION = "0.1.0"

  # A Javascript Engine
  class Engine
    def initialize(size : Int32 = 8192)
      @js = Elk.js_create((" "*size), size)
    end

    def set_global(name : String, value : Elk::Jsval)
      Elk.js_set(@js, Elk.js_glob(@js), name, value)
    end

    def eval(code : String)
      Elk.js_eval(@js, code, code.bytesize)
    end

    def make_func(&)
    end

    def self.from_jsval(js : Elk::Js, val : Elk::Jsval)
      # FIXME: handle JS_UNDEFINED, JS_ERR, JS_PRIV
      case Elk.js_type(val)
      when 1 # Elk::JsTypes::JS_NULL
        nil
      when 2 # Elk::JsTypes::JS_TRUE
        true
      when 3 # Elk::JsTypes::JS_FALSE
        false
      when 4 # Elk::JsTypes::JS_STR
        size : UInt64 = 0
        buffer = Elk.js_getstr(js, val, pointerof(size))
        String.new(buffer, size)
      when 5 # Elk::JsTypes::JS_NUM
        Elk.js_getnum(val)
      end
    end
  end

  # Wraps a block in a function that can be called from Javascript
  macro func(block)
    Elk.js_mkfun(->(js : Elk::Js, args : Elk::Jsval*, nargs : UInt32) : Elk::Jsval {
      p_args = (0...nargs).map { |i|
        Js::Engine.from_jsval(js, args[i])
      }

      {{block}}.call(p_args)
    })
  end

  alias Args = Array(String | Bool | Nil | Float64)

  UNDEF = Elk.js_mkundef
end

js = Js::Engine.new

js.set_global("print", Js.func(->(args : Js::Args) {
  args.each do |arg|
    puts arg
  end
  Js::UNDEF
}))

js.eval("print('Hello, World!', 42);")
