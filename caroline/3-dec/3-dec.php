<?php
$char_pattern = '/[^0-9.\n]/';
$lines = file("input.txt");
$y_count = 0;
$char_positions = array();
$nums = array();
foreach( $lines as $line )
 {
    $x_count = 0;
    $chars = str_split($line);
    $last_char_int = false;
    $current_int_tracker = 0;
    preg_match_all('/[0-9]+/', $line, $numbers);
    foreach( $chars as $char ){
      if ( (preg_match($char_pattern, $char)) && $x_count !== 140 ){
        $position = new Position($x_count, $y_count);
        array_push($char_positions, $position);
      } elseif ( preg_match('/[0-9]/', $char) && ( $last_char_int === false )){
        $new_int = new Part_Number($x_count, $y_count, (int)($numbers[0][$current_int_tracker]));
        array_push($nums, $new_int);
        $current_int_tracker += 1;
      }
      if ( preg_match('/[0-9]/', $char) ){
        $last_char_int = true;
      } else {
        $last_char_int = false;
      }
      $x_count += 1;
    }
    $y_count += 1;
 }

$total_value = 0;
foreach ($nums as $num){
  $num_valid = false;
  foreach ($char_positions as $char){
    if ($char->y == $num->start->y || $char->y == $num->start->y - 1 || $char->y == $num->start->y + 1 ){
      if (proximity_pass($num, $char)){
        $num_valid = true;
      }
    }
  }
  if ($num_valid){
    $total_value += $num->value;
  }
}
echo '<br>' . $total_value;

 class Position {
  public $x = 0;
  public $y = 0;

  function __construct($x, $y){
    $this->x = $x;
    $this->y = $y;
  }
 }

class Part_Number {
  public Position $start;
  public int $length;
  public int $value;

  function __construct( int $x_val, int $y_val, int $int_value ){
    $this->start = new Position($x_val, $y_val);
    $this->length = strlen((string)$int_value);
    $this->value = $int_value;
  }
}

function proximity_pass(Part_Number $part, Position $special_character){
  $char_x = $special_character->x;
  $char_y = $special_character->y;

  $num_x = $part->start->x;
  $num_y = $part->start->y;
  $num_length = $part->length;

  if ( ($char_y == $num_y) && ( ($char_x == ($num_x - 1) )|| ($char_x == ($num_x + $num_length)))){
    return true;
  } else if ( (($char_y == $num_y + 1) || ($char_y == $num_y - 1) ) && (( $char_x >= ($num_x - 1) && ($char_x <= ($num_x + $num_length)) ))){
    return true;
  }
  else return false;
}
