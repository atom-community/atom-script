#!/usr/bin/swift

// To use this file as script:
/*
 $ chmod +x /path/to/file.swift
 $ /path/to/file.swift
 > Hello, World
*/

import Swift

public func greet(receiver: String) {
  print("Hello, \(receiver)")
}

greet("World")
