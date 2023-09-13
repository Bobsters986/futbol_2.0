require 'csv'
require_relative 'game'

class StatTracker
  attr_reader :games,
              :teams,
              :game_teams

  def initialize(locations)
    @games = games_csv(locations)
    @teams = teams_csv(locations)
    @game_teams = game_teams_csv(locations)
  end

  def games_csv(locations)
    games = []

    CSV.foreach(locations[:games], headers: true, header_converters: :symbol) do |row|
      games << Game.new(row)
    end

    games
  end

  def teams_csv(locations)
    teams = []

    CSV.foreach(locations[:teams], headers: true, header_converters: :symbol) do |row|
      teams << row
    end

    teams
  end

  def game_teams_csv(locations)
    game_teams = []

    CSV.foreach(locations[:game_teams], headers: true, header_converters: :symbol) do |row|
      game_teams << row
    end

    game_teams
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def highest_total_score
    games.map do |game|
      game.away_goals + game.home_goals
    end.max
  end

  def lowest_total_score
    games.map do |game|
      game.away_goals + game.home_goals
    end.min
  end
end