<?php
$pattern = '/[^0-9.]/';
$lines = file("input.txt");
$y_count = 0;
$char_positions = array();
foreach( $lines as $line )
 {
    $x_count = 0;
    $chars = str_split($line);
    foreach( $chars as $char ){
      if ( preg_match($pattern, $char) ){
        $position = new Position($x_count, $y_count);
        array_push($char_positions, $position);
        print_r($position);
      }
      $x_count += 1;
      echo 'x: ' . $x_count . '<br>';
    }
    $y_count += 1;
    echo 'y: ' . $y_count . '<br>';
 }
//  print_r($char_positions);

 class Position {
  public $x = 0;
  public $y = 0;

  function __constructor($x, $y){
    $this->x = $x;
    $this->y = $y;
  }

  function proximity_pass(Position $num_start_position, int $num){
    $x = $this->x;
    $y = $this->y;

    // test x for proximity
    if ( ($y === $num_start_position->y) && ( $x === ($num_start_position->x - 1) || $x === ($num_start_position->x + count_chars((string)$num) + 1) )){
      return true;
    }

    // test y for proximity
  }
 }
