<?php
$cards = array();
$matches = array();
$total_score = 0;
$card_qty = 0;
$cards_to_count = array();
$lines = file( "input.txt" );

foreach ( $lines as $line ) {
  $values = (preg_split('/([:|]+)/', $line));
  $id = format_numbers( $values[0] );
  $winners = format_numbers( $values[1] );
  $contents = format_numbers( $values[2] );
  $card = new Card( $id, $winners, $contents );
  $card_qty += 1;
  $cards[$card->id] = $card;
  array_push( $cards_to_count, $card );
}

echo 'initial card quantity: ' . $card_qty . '<br>';

foreach ( $cards as $card ){
  $matches = $card->match_finder();
  $total_score += $card->card_tally( $matches );
}
echo 'total score of cards (part 1): ' . $total_score;

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

do {
  $card_object = array_shift( $cards_to_count ); // this line will make your browser cry, apparently
  $list = $card_object->new_cards;
  foreach ( $list as $item ){
    $current_card = $cards[$item];
    array_push( $cards_to_count, $current_card );
    $card_qty += 1;
  }
} while ( count( $cards_to_count ) > 0 );
echo 'card quantity after going nuts: ' . $card_qty . '<br>';

class Card {
  public int $id;
  public array $winners;
  public array $card_contents;
  public int $matches;
  public array $new_cards;

  function __construct( int $id, array $winners, array $contents ){
    $this->id = $id;
    $this->winners = $winners;
    $this->card_contents = $contents;
    $this->match_tally();
    $this->get_new_cards();
  }

  function match_finder(){
    return array_intersect( $this->winners, $this->card_contents );
  }

  function get_new_cards(){
    $new_cards_array = array();
    for ( $i = 1; $i < $this->matches; $i += 1 ){
      if ( $this->id + $i < 204 ){
        $card_num = $this->id + $i;
        array_push( $new_cards_array, $card_num);
      }
    }
    $this->new_cards = $new_cards_array;
  }

  function match_tally() {
    $this->matches = count( $this->match_finder() );
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
