#!/usr/bin/env osascript -l JavaScript

test = Application.currentApplication()

test.includeStandardAdditions = true

test.displayDialog("Hello world")
