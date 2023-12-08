<?php
$lines = file( __DIR__ . '/input.txt');
$coordinates = array();
$directions = '';
$header = true;
foreach( $lines as $line ){
  $step = array();
  $step = preg_split('/([^A-Z]+)/', $line);
  $step = array_filter( $step );
  if ( empty($step) ){
    continue;
  }
  if( $header === true ){
    $header = false;
    $directions = str_split($step[0]);
    continue;
  }
  $coordinates[$step[0]] = array( $step[1], $step[2] );
}

$started = false;
$counter = 0;
$found = false;
$curr_loc = '';

while ( $found === false ){
  foreach( $directions as $direction ){
    if( $started === false ){
      $started = true;
      $curr_loc = router( 'AAA', $direction );
    } else {
      $curr_loc = router( $curr_loc, $direction );
    }
    if ( $curr_loc === 'ZZZ' ){
      $found = true;
    }
    $counter += 1;
  }
}
echo $counter;


function router( string $coordinate, string $direction ){
  global $coordinates;
  $index = 0;
  if ( $direction === 'R' ){
    $index = 1;
  }
  return $coordinates[$coordinate][$index];
}
