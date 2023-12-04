<?php

// MAIN PROGRESSION //
$char_pattern = '/[^0-9.\n]/'; // match pattern for finding correct special characters
$lines = file( "input.txt" );
$y_count = 0; // y-axis location
$char_positions = array(); // store for identified special characters
$nums = array(); // store for identified numbers and their properties
$asterisks = array(); // store for '*' characters and their properties
$gear_total = 0; // store for totalled identified gear ratios

// identify and store chars, numbers, and potential gear asterisks
foreach( $lines as $line )
 {
    $x_count = 0; // x-axis location
    $chars = str_split( $line );
    preg_match_all( '/[0-9]+/', $line, $numbers ); // create array of this line's integers
    $current_int_tracker = 0; // track which identified integer has been stored
    $last_char_int = false; // track whether current char is the first of a number
    foreach( $chars as $char ){
      if (( preg_match( $char_pattern, $char )) && $x_count !== 140 ){ // identify and store special characters
        $position = new Position( $x_count, $y_count );
        array_push($char_positions, $position);
        if ( $char === '*' ){ // identify and store asterisk
          $asterisk = new Gear( $position );
          array_push( $asterisks, $asterisk );
        }
      } elseif ( preg_match('/[0-9]/', $char ) && ( $last_char_int === false )) { // identify and store numbers
        $new_int = new Part_Number($x_count, $y_count, (int)( $numbers[0][$current_int_tracker] ));
        array_push($nums, $new_int);
        $current_int_tracker += 1;
      }
      if ( preg_match( '/[0-9]/', $char )) { // track if char is first digit of a number
        $last_char_int = true;
      } else {
        $last_char_int = false;
      }
      $x_count += 1;
    }
    $y_count += 1;
 }

$total_value = 0;
// if a number is close to a special char, add its value to the running total
foreach ( $nums as $num ){
  $num_valid = false; // bool so that num will only be added once
  foreach ( $char_positions as $char ){
    // check if the current char is in the 3 lines surrounding the current number
    if ( $char->y == $num->start->y || $char->y == $num->start->y - 1 || $char->y == $num->start->y + 1 ) {
      if ( proximity_pass($num, $char )) {
        $num_valid = true;
      }
    }
  }
  if ( $num_valid ) {
    $total_value += $num->value;
  }
  foreach ( $asterisks as $asterisk ) {
    gear_finder($num, $asterisk);
  }
}
echo 'parts total: ' . $total_value . '<br>';

foreach ( $asterisks as $asterisk ) {
  if ( $asterisk->get_size() === 2 ) {
    $gear_total += $asterisk->get_ratio();
  }
}
echo 'gear total: ' . $gear_total;

// CLASSES //
class Position {
  public $x = 0;
  public $y = 0;

  function __construct( $x, $y ){
    $this->x = $x;
    $this->y = $y;
  }
}

class Part_Number {
  public Position $start;
  public int $length;
  public int $value;

  function __construct( int $x_val, int $y_val, int $int_value ){
    $this->start = new Position( $x_val, $y_val );
    $this->length = strlen(( string)$int_value );
    $this->value = $int_value;
  }
}

class Gear {
  public Position $position;
  public $parts = array();

  function __construct( Position $pos ) {
    $this->position = $pos;
  }

  function get_size() {
    return count( $this->parts );
  }

  function get_ratio(){
    $ratio = 1;
    foreach( $this->parts as $part ){
      $ratio *= $part->value;
    }
    return $ratio;
  }
}

// FUNCTIONS FOR MAIN PROGRESSION //
// if a number is close to an asterisk, add it to the asterisk's array of numbers
function gear_finder( Part_Number $part, Gear $gear ){
  if (proximity_pass( $part, $gear->position )){
    array_push( $gear->parts, $part );
  }
}

// bool for whether a number and a position are considered adjacent
function proximity_pass( Part_Number $part, Position $special_character ){
  $char_x = $special_character->x;
  $char_y = $special_character->y;

  $num_x = $part->start->x;
  $num_y = $part->start->y;
  $num_length = $part->length;

  if (( $char_y == $num_y ) && (( $char_x == ( $num_x - 1 )) || ( $char_x == ( $num_x + $num_length )))) {
    return true;
  } else if ((( $char_y == $num_y + 1 ) || ( $char_y == $num_y - 1 )) && (( $char_x >= ( $num_x - 1 ) && ( $char_x <= ( $num_x + $num_length ))))) {
    return true;
  }
  else return false;
}
