<?php
$lines = file("input.txt");
$total_valid_games = 0;
$total_game_power = 0;
$red_max = 12;
$green_max = 13;
$blue_max = 14;
foreach($lines as $line)
 {
    $first_split = explode(':', $line, 2);
    $game_tag = $first_split[0];
    $game_id = explode(' ', $game_tag, 2);
    $game = new Game((int)$game_id[1]);
    $rounds = explode(';', $first_split[1]);
    foreach ($rounds as $round) {
      $cube_colors = explode(',', $round);
      $red = 0;
      $green = 0;
      $blue = 0;
      foreach ($cube_colors as $cube_color){
        $pairs = explode(' ', $cube_color);
        if (trim($pairs[2]) === 'red'){
          $red = (int)$pairs[1];
          if ($red > $red_max){
            $game->is_valid = false;
          }
        } elseif (trim($pairs[2]) === 'green') {
          $green = (int)$pairs[1];
          if ($green > $green_max){
            $game->is_valid = false;
          }
        } elseif (trim($pairs[2]) === 'blue') {
          $blue = (int)$pairs[1];
          if ($blue > $blue_max){
            $game->is_valid = false;
          }
        }
      }
      $round = new Round($red, $green, $blue);
      $game->add_round($round);
    }
    $total_game_power += $game->lowest_cube();
    if ($game->is_valid){
      $total_valid_games += $game->id;
    }
 }
 echo 'total for valid games: ' . $total_valid_games . '<br>';
 echo 'total for game power: ' . $total_game_power . '<br>';


class Game {
  public $id;
  public $rounds = array();
  public $is_valid = true;

  function __construct($game_id) {
    $this->id = $game_id;
  }

  function add_round(Round $new_round) {
    array_push($this->rounds, $new_round);
  }

  function lowest_cube() {
    $red_lowest = 0;
    $green_lowest = 0;
    $blue_lowest = 0;
    foreach($this->rounds as $round){
      if ($round->red > $red_lowest){
        $red_lowest = $round->red;
      }
      if ($round->green > $green_lowest){
        $green_lowest = $round->green;
      }
      if ($round->blue > $blue_lowest){
        $blue_lowest = $round->blue;
      }
    }
    return $red_lowest * $green_lowest * $blue_lowest;
  }
}

class Round {
  public $red = 0;
  public $green = 0;
  public $blue = 0;

  function __construct($red, $green, $blue) {
    $this->red = $red;
    $this->green = $green;
    $this->blue = $blue;
  }
}
?>
