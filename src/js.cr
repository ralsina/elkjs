require "./elk.cr"

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

    def self.to_jsval(js : Elk::Js, val)
      case val
      when Nil
        Elk.js_mknull
      when Bool
        val ? Elk.js_mktrue : Elk.js_mkfalse
      when String
        Elk.js_mkstr(js, val, val.bytesize)
      when Number
        Elk.js_mknum(js, val)
      else
        Elk.js_mkundef
      end
    end

    def self.from_jsval(js : Elk::Js, val : Elk::Jsval)
      # FIXME: handle JS_UNDEFINED, JS_ERR, JS_PRIV
      case Elk.js_type(val)
      when Elk::JsTypes::JS_NULL.value
        nil
      when Elk::JsTypes::JS_TRUE.value
        true
      when Elk::JsTypes::JS_FALSE.value
        false
      when Elk::JsTypes::JS_STR.value
        size : UInt64 = 0
        buffer = Elk.js_getstr(js, val, pointerof(size))
        String.new(buffer, size)
      when Elk::JsTypes::JS_NUM.value
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

        return Js::Engine.to_jsval(js, {{block}}.call(p_args))
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
  99
  #   Js::UNDEF # Return undefined
}))

js.eval("print(print('Hello, World!', 42));")
