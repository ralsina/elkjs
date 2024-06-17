require "../src/js.cr"

js = Js::Engine.new

js.set_global("print", Js.func(->(args : Js::Args) {
  args.each do |arg|
    puts arg
  end
  Js::UNDEF # Return undefined
}))

js.eval("print('Hello, World!');")
js.eval("print(1+2);")
js.eval("
let f = function(i) { return i*2; };
for (let i=0; i<5; i++) {
    print(f(i));
}")

