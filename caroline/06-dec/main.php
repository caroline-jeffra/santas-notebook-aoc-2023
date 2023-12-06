<?php
$lines = file( "input.txt" );
$record_values = array();
foreach( $lines as $line ){
  $data = preg_split( '/([\s:]+)/', $line );
  $key = lcfirst( array_shift( $data ));
  $record_values[$key] = implode( $data );
}

$times = $record_values['time'];
$distances = $record_values['distance'];

echo win_tester( (int)$times, (int)$distances );

function win_tester ( int $time, int $record ){
  $win_states = 0;
  for ( $i = 1; $i < $time - 1; $i++ ){
    $distance = $i * ( $time - $i );
    if ( $distance > $record ){
      $win_states += 1;
    }
  }
  return $win_states;
}
