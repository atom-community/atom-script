; Adapted from http://rosettacode.org/wiki/Fibonacci_sequence#Racket

#lang racket

(define (fib n)
  (let loop ((cnt 0) (a 0) (b 1))
    (if (= n cnt)
        a
        (loop (+ cnt 1) b (+ a b)))))

(fib 100)
