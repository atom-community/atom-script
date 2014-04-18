<?php

/** From http://docs.behat.org/quick_intro.html#writing-your-step-definitions */

use Behat\Behat\Context\BehatContext,
    Behat\Behat\Exception\PendingException;
use Behat\Gherkin\Node\PyStringNode,
    Behat\Gherkin\Node\TableNode;

class FeatureContext extends BehatContext
{
    /**
     * @Given /^I am in a directory "([^"]*)"$/
     */
    public function iAmInADirectory($dir)
    {
        if (!file_exists($dir)) {
            mkdir($dir);
        }
        chdir($dir);
    }

    /** @Given /^I have a file named "([^"]*)"$/ */
    public function iHaveAFileNamed($file)
    {
      touch($file);
    }

    /** @When /^I run "([^"]*)"$/ */
    public function iRun($command)
    {
      exec($command, $output);
      $this->output = trim(implode("\n", $output));
    }

    /** @Then /^I should get:$/ */
    public function iShouldGet(PyStringNode $string)
    {
      if ((string) $string !== $this->output) {
        throw new Exception(
          "Actual output is:\n" . $this->output
        );
      }
    }
}
