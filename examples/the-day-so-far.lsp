#!/usr/bin/newlisp

(format "the day is %2.0f%% done"  (div (time-of-day) (* 24 60 60 10)))
