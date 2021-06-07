#!/usr/bin/env ruby

require "pry-byebug"

require File.join(File.join(__dir__, "..", "config", "initializers", "zeitwerk"))

# setup a new game
game = Game.new
dealer = game.dealer || Dealer.new

# setup new players
artisan = Player.new name: "5. Considers technologies akin to playing with Legos (TM)"
engineer = Player.new name: "4. More than one language, best-practices"
developer = Player.new name: "3. One language, less than 5 yrs XP"
syntax_jockey = Player.new name: "2. Bootcamp graduate"
not_a_coder = Player.new name: "1. Bossen"
players = [artisan, engineer, developer, syntax_jockey, not_a_coder].shuffle

# simulate players entering the game in random order
players[0..-2].shuffle.each(&:enter_game)

# pick a random player for no apparent reason
player = game.players.to_a.sample

# which player has yet to join the game?
queued_player = players.detect{|player|
 (players.map(&:name) - game.players.to_a.map(&:name)).include?(player.name)
}

# make that player enter the game
queued_player.enter_game

true
