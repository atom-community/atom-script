#!/usr/bin/env node
var open = require("nodegit").Repository.open;
var fs = require('fs');

// node runtime is relative, whereas the package.json file is relative to cwd
var pkg = require('../package.json')

var authors = {}
var rankings = {}

var PREVIOUS_RELEASE_NOTE = new RegExp("^Prepare " + pkg["version"] + " release\s*");
var accumulatedChanges = []
var collecting = true;

var ignore = {
  "dev": "dev@debian7devel",
  "=": "="
}

open(".")
  .then(function(repo) {
    return repo.getHeadCommit();
  })
  // Display information about commits at HEAD
  .then(function(headCommit) {
    // Create a new history event emitter.
    var history = headCommit.history();
  
    // Listen for commit events from the history.
    history.on("commit", function(commit) {
      var author = commit.author();
      var name = author.name();
      var email = author.email();

      var message = commit.message();

      if (collecting) {
        if(message.match(PREVIOUS_RELEASE_NOTE)){
          collecting = false;
        }
        else {
          accumulatedChanges.push(message);
        }
      }

      if (! ( ignore[name] && ignore[name] === email )) {
        // Take their most recent commit as the email they care about
        // Assumes everyone has a unique name
        authors[name] = authors[name] || email;
        
        // Count up their total number of commits
        rankings[name] = rankings[name] || 0
        rankings[name]++
      }

    });

    history.on("end", function(commits) {

      console.log("Summarize these for the CHANGELOG: ");
      console.log(">>>>>>>>>>>>>>>");
      for (var i = 0; i < accumulatedChanges.length; i++) {
        console.log(accumulatedChanges[i]);
      }
      console.log("<<<<<<<<<<<<<<<");

      // Create the updated contributors array
      var contributors = []
      for (var name in rankings) {
        contributors.push({"name": name, "email": authors[name]})
      }
      pkg['contributors'] = contributors;

      fs.writeFile("package.json", JSON.stringify(pkg, null, 2), function(err) {
        if (err) {
          console.err(err);
        }
        else {
          console.log("package.json written");
        }
      });

    });
  
    // Start emitting events.
    history.start();
  });

