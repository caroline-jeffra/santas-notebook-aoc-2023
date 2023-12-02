<?php
class Round {
  public $red = 0;
  public $green = 0;
  public $blue = 0;

  function __construct($red, $green, $blue) {
    $this->red = $red;
    $this->green = $green;
    $this->blue = $blue;
  }
}

foreach( file('input.txt') as $line ) {
  echo $line;
}
?>
