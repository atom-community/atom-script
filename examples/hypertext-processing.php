<?php

function …()
{
    $args = func_get_args();

    foreach ($args as $arg) {
        echo $arg . "\n";
    }
}

…("Unicode", "works", "great", "in PHP");
