namespace HelloWorld

module Greeter =
  let SayHelloTo name = printf "Hello %s!" name

module Main =
  Greeter.SayHelloTo "World"
