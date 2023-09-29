require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'

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
      teams << Team.new(row)
    end

    teams
  end

  def game_teams_csv(locations)
    game_teams = []

    CSV.foreach(locations[:game_teams], headers: true, header_converters: :symbol) do |row|
      game_teams << GameTeam.new(row)
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

  def percentage_home_wins
    home_wins = game_teams.count do |gt|
      gt.result == "WIN" && gt.hoa == "home"
    end
    (home_wins.to_f / games.size.to_f).round(2)
  end

  def percentage_visitor_wins
    visitor_wins = game_teams.count do |gt|
      gt.result == "WIN" && gt.hoa == "away"
    end
    (visitor_wins.to_f / games.size.to_f).round(2)
  end

  def percentage_ties
    ties = game_teams.count do |gt|
      gt.result == "TIE" && gt.hoa == "home"
    end
    (ties.to_f / games.size.to_f).round(2)
  end

  def count_of_games_by_season
    games.each_with_object(Hash.new(0)) do |game, hash|
      hash[game.season] += 1
    end
  end

  def average_goals_per_game
    goals = 0

    games.each do |game|
      goals += (game.home_goals + game.away_goals)
    end

    total = goals / games.size.to_f

    total.round(2)
  end

  
end