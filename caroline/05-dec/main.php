<?php
$lines = file( "input.txt" );
$data_line = false;
$conversion_type = 0;
$seed_nums = array();
$seeds = array();

$seed_soil = array();
$soil_fert = array();
$fert_water = array();
$water_light = array();
$light_temp = array();
$temp_hum = array();
$hum_loc = array();

foreach( $lines as $line ){
  if ( str_contains( $line, ':') ){
    $metadata = input_text_parse( $line );
    if ( gettype( $metadata ) === 'array' ){
      $seed_nums = $metadata;
    } elseif ( gettype( $metadata ) === 'integer' ) {
      $conversion_type = $metadata;
    }
  } elseif ( $line != '' ) {
    $range_entry = input_data_mapper( $line );
    switch ($conversion_type) {
      case 1:
        array_push( $seed_soil, $range_entry );
        break;
      case 2:
        array_push( $soil_fert, $range_entry );
        break;
      case 3:
        array_push( $fert_water, $range_entry );
        break;
      case 4:
        array_push( $water_light, $range_entry );
        break;
      case 5:
        array_push( $light_temp, $range_entry );
        break;
      case 6:
        array_push( $temp_hum, $range_entry );
        break;
      case 7:
        array_push( $hum_loc, $range_entry );
        break;
      default:
        break;
    }
  } else {
    echo 'line was blank<br>';
  }
}

$converters = array(
  'seed_soil'=>array_filter( $seed_soil ),
  'soil_fert'=>array_filter( $soil_fert ),
  'fert_water'=>array_filter( $fert_water ),
  'water_light'=>array_filter( $water_light ),
  'light_temp'=>array_filter( $light_temp ),
  'temp_hum'=>array_filter( $temp_hum ),
  'hum_loc'=>array_filter( $hum_loc )
);

$seeds = create_seeds( $seed_nums );

plan_planting( $seeds, $converters );

function create_seeds( array $seed_nums ){
  $built_seeds = array();
  foreach ( $seed_nums as $seed_num ){
    $seed = new Seed( $seed_num );
    array_push( $built_seeds, $seed );
  }
  return $built_seeds;
}

function plan_planting( array $seeds, array $converters ){
  foreach ( $seeds as $seed ){
    $seed->planting_plan( $converters );
    print_r( $seed->location );
    echo '<br>';
  }
}

function input_text_parse( string $line ){ // takes a non-number line and processes
  if ( str_contains( $line, 'seeds:' ) === true ){
    $values = preg_split('/(\s)/', $line);
    array_shift( $values );
    return array_filter( $values );
  } elseif ( $line != '' ) {
    if ( str_contains( $line, 'seed-to-soil map:' ) === true ){
      return 1;
    } elseif ( str_contains( $line, 'soil-to-fertilizer map:' ) === true ){
      return 2;
    } elseif ( str_contains( $line, 'fertilizer-to-water map:' ) === true ) {
      return 3;
    } elseif ( str_contains( $line, 'water-to-light map:' ) === true ) {
      return 4;
    } elseif ( str_contains( $line, 'light-to-temperature map:' ) === true ) {
      return 5;
    } elseif ( str_contains( $line, 'temperature-to-humidity map:' ) === true ) {
      return 6;
    } elseif ( str_contains( $line, 'humidity-to-location map:' ) === true ) {
      return 7;
    }
  }
}

function input_data_mapper( string $raw_values ){ // takes line of values and formats for insertion into approp. array.
  $values = explode(' ', $raw_values);
  if ( isset($values[1] ) || isset($values[2] ) ){
    $keyed_values = array( 'source_start'=>(int)$values[1], 'dest_start'=>(int)$values[0], 'range_length'=>(int)$values[2] );
    return $keyed_values;
  } else {
  }
}

function auto_convert( int $source_value, array $conversion_maps ){ // converts a start value into its output type value
  foreach ( $conversion_maps as $map ){
    $range_base = $map['source_start'];
    $range_top = $range_base + $map['range_length'] - 1;
    if (( $source_value >= $range_base ) && ( $source_value <= $range_top )){
      $offset = $source_value - $range_base;
      return $map['dest_start'] + $offset;
    }
  }
  return $source_value;
}

class Seed {
  public int $id;
  public int $soil;
  public int $fertilizer;
  public int $water;
  public int $light;
  public int $temp;
  public int $humidity;
  public int $location;

  function __construct( int $id ) {
    $this->id = $id;
  }

  function planting_plan( array $converters ){
    $this->soil = auto_convert( $this->id, $converters['seed_soil'] );
    $this->fertilizer = auto_convert( $this->soil, $converters['soil_fert'] );
    $this->water = auto_convert( $this->fertilizer, $converters['fert_water'] );
    $this->light = auto_convert( $this->water, $converters['water_light'] );
    $this->temp = auto_convert( $this->light, $converters['light_temp'] );
    $this->humidity = auto_convert( $this->temp, $converters['temp_hum'] );
    $this->location = auto_convert( $this->humidity, $converters['hum_loc']);
  }
}
