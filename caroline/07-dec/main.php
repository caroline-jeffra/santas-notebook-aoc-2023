<?php
$all_hands = array();
$recoder = array(
  'A'=>'N',
  'K'=>'M',
  'Q'=>'L',
  'J'=>'K',
  'T'=>'J',
  '9'=>'I',
  '8'=>'H',
  '7'=>'G',
  '6'=>'F',
  '5'=>'E',
  '4'=>'D',
  '3'=>'C',
  '2'=>'B',
  '1'=>'A'
);
$lines = file( __DIR__ . '/input.txt' );
foreach( $lines as $line ){
  $hand = explode( ' ', $line );
  $hand_chars = str_split( $hand[0] );
  $hand_coded = array();
  foreach( $hand_chars as $char ){
    $char = $recoder[$char];
    array_push( $hand_coded, $char );
  }
  $hand[0] = implode( $hand_coded );
  $hand[1] = ( int )$hand[1];
  $hand[2] = hand_type( $hand[0] );
  array_push( $all_hands, $hand );
}

$hand_values = array_column( $all_hands, 0);
$bet_values = array_column( $all_hands, 1);
$hand_types = array_column( $all_hands, 2);

array_multisort( $hand_types, SORT_ASC, $hand_values, SORT_ASC, $bet_values);

$pivot_values = array( $hand_values, $bet_values, $hand_types );
$total_winnings = 0;
foreach ( $bet_values as $key => $bet){
  $bet_win = ( $key + 1 ) * $bet;
  $total_winnings += $bet_win;
}
echo $total_winnings;

function hand_type( string $hand ){
  $counter = array();
  foreach( count_chars( $hand, 1) as $i => $qty ){
    $counter[chr($i)] = $qty;
  }
  switch (count($counter)) {
    case 1:
      return 7;
    case 2:
      if ( in_array( 4, $counter )){
        return 6;
      } else {
        return 5;
      }
    case 3:
      if ( in_array( 3, $counter )){
        return 4;
      } else {
        return 3;
      }
    case 4:
      return 2;
    case 5:
      return 1;
    default:
      print_r('error in hand_type. counter_size returning invalid length');
      break;
  }
}
?>
