<?php
$cards = array();
$matches = array();
$total_score = 0;
$lines = file( "input.txt" );

foreach ( $lines as $line ) {
  $values = (preg_split('/([:|]+)/', $line));
  $id = format_numbers( $values[0] );
  $winners = format_numbers( $values[1] );
  $contents = format_numbers( $values[2] );
  $card = new Card( $id, $winners, $contents );
  array_push( $cards, $card );
}

foreach ( $cards as $card ){
  $matches = $card->match_finder();
  $total_score += $card->card_tally( $matches );
}
echo $total_score;


function format_numbers( String $value_string ){
  $value_string = trim($value_string);
  $values_array = preg_split('/([\s]+)/', $value_string);
  if ( $values_array[0] === 'Card' ) {
    return ( int )$values_array[1];
  } else {
    foreach ( $values_array as $value ) {
      $value = ( int )$value;
    }
    return $values_array;
  }
}

class Card {
  public int $id;
  public array $winners;
  public array $card_contents;

  function __construct( int $id, array $winners, array $contents ){
    $this->id = $id;
    $this->winners = $winners;
    $this->card_contents = $contents;
  }

  function match_finder(){
    return array_intersect( $this->winners, $this->card_contents );
  }

  function card_tally ( array $matches ){
    if ( count( $matches ) >= 1 ) {
      $total = 0.5;
      foreach ( $matches as $match ){
        $total *= 2;
      }
      return $total;
    } else {
      return 0;
    }
  }
}
