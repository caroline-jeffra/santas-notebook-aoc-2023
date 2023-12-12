<?php

$lines = file( __DIR__ . '/input.txt');
$x_empty = array();
$y_empty = array();
$galaxy_number = 1;
$galaxies = array();
$x_max = array();
$y_current = 0;

foreach( $lines as $line ){
  $values = str_split( trim( $line ));
  $values = array_filter( $values );
  $galaxy_found = false;
  foreach( $values as $key=>$item ){
    if( !isset( $x_max[$key] )){
      $x_max[$key] = true;
    }
    if( $item === '#' ){
      $galaxy_found = true;
      array_push( $x_empty, $key );
      $galaxy = new Galaxy( $galaxy_number, $key, $y_current );
      array_push( $galaxies, $galaxy);
      $galaxy_number += 1;
    }
  }
  if( $galaxy_found == false ){
    array_push( $y_empty, $y_current );
    $y_current += 2;
  } else {
    $y_current += 1;
  }
}
print_r( $galaxies[6] );

$expansion_spaces['X'] = gen_empty_cols( $x_empty, $x_max );
$expansion_spaces['Y'] = $y_empty;

print_r( $expansion_spaces );

expand_galaxies( $expansion_spaces['X'], $galaxies );

print_r( $galaxies[6] );

print_r( find_distances( $galaxies ));

function find_distances( array $all_galaxies ){
  $gal_count = count( $all_galaxies );
  $length = 0;
  for ( $i = 0; $i < $gal_count - 1; $i++ ) {
    for ( $j = $i + 1; $j < $gal_count; $j++ ) {
      $length += $all_galaxies[$i]->distance( $all_galaxies[$j] );
    }
  }
  return $length;
}

function expand_galaxies( array $expansion_cols, array $all_galaxies ){
  foreach( $all_galaxies as $galaxy ){
    $galaxy->offsetter( $expansion_cols );
  }
}

function gen_empty_cols( array $x_cols_status, array $x_maximum_keys ){
  $x_cols_status = array_unique( $x_cols_status );
  rsort( $x_cols_status );
  $x_add = array();
  foreach( $x_maximum_keys as $key=>$value ){
    if( !in_array( $key, $x_cols_status )){
      array_unshift( $x_add, $key );
    }
  }
  return $x_add;
}

class Galaxy {
  public int $id;
  public int $x;
  public int $y;

  function __construct( int $id, int $x, int $y ){
    $this->id = $id;
    $this->x = $x;
    $this->y = $y;
  }

  function distance( Galaxy $comparison ){
    $high_y = 0;
    $low_y = 0;
    $high_x = 0;
    $low_x = 0;
    if( $this->y > $comparison->y ){
      $high_y = $this->y;
      $low_y = $comparison->y;
    } else {
      $high_y = $comparison->y;
      $low_y = $this->y;
    }
    if( $this->x > $comparison->x ){
      $high_x = $this->x;
      $low_x = $comparison->x;
    } else {
      $high_x = $comparison->x;
      $low_x = $this->x;
    }
    $diff = ( $high_y - $low_y ) + ( $high_x - $low_x );
    return $diff;
  }

  function offsetter( array $expansion_locations ){
    foreach( $expansion_locations as $location ){
      $offset_count = 0;
      if( $this->x > $location ){
        $offset_count += 1;
        $this->x += 1;
      }
    }
  }
}
