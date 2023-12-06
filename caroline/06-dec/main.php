<?php
$lines = file( "input.txt" );
$record_values = array();
foreach( $lines as $line ){
  $data = preg_split( '/([\s:]+)/', $line );
  $key = lcfirst( array_shift( $data ));
  $record_values[$key] = $data;
}
print_r( $record_values );
echo '<br>';

$times = $record_values['time'];
$distances = $record_values['distance'];

$error_margin = 1;
for ( $i = 0; $i < count($times) - 1; $i++ ){
  $error_margin *= win_tester( (int)$times[$i], (int)$distances[$i] );
}
echo $error_margin;

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
