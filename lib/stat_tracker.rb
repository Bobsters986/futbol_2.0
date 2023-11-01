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

  def average_goals_by_season
    all_goals_per_season = games.each_with_object(Hash.new(0)) do |game, hash|
      hash[game.season] += (game.home_goals + game.away_goals)
    end

    all_goals_per_season.each do |season, goals|
      all_goals_per_season[season] = (goals.to_f / count_of_games_by_season[season]).round(2)
    end
  end

  def count_of_teams
    teams.size
  end

  def find_team_name(team_id)
    teams.find do |team|
      team.team_id == team_id
    end.team_name
  end

  def team_score_averages
    team_id_hash = Hash.new{|k,v| k[v] = []}
    games.each do |game|
      team_id_hash[game.away_team_id] << game.away_goals.to_f
      team_id_hash[game.home_team_id] << game.home_goals.to_f
    end

    goal_average_hash = Hash.new
    team_id_hash.each do |team_id, score_array|
      goal_average_hash[team_id] = (score_array.sum / score_array.size).round(4)
    end

    goal_average_hash.sort_by {|key, value| value}
  end

  def best_offense
    find_team_name(team_score_averages.last[0])
  end

  def worst_offense
    find_team_name(team_score_averages.first[0])
  end

  def highest_scoring_visitor
    visitor_hash = Hash.new{|k,v| k[v] = []}
    games.each do |game|
      visitor_hash[game.away_team_id] << game.away_goals.to_f
    end

    visitor_average_hash = Hash.new
    visitor_hash.each do |team_id, score_array|
      visitor_average_hash[team_id] = (score_array.sum / score_array.size).round(4)
    end

    sorted_visitor_scores = visitor_average_hash.sort_by {|key, value| value}

    find_team_name(sorted_visitor_scores.last[0])
  end

  def highest_scoring_home_team
    home_hash = Hash.new{|k,v| k[v] = []}
    games.each do |game|
      home_hash[game.home_team_id] << game.home_goals.to_f
    end

    home_average_hash = Hash.new
    home_hash.each do |team_id, score_array|
      home_average_hash[team_id] = (score_array.sum / score_array.size).round(4)
    end

    sorted_home_scores = home_average_hash.sort_by {|key, value| value}

    find_team_name(sorted_home_scores.last[0])
  end

  def lowest_scoring_visitor
    visitor_hash = Hash.new{|k,v| k[v] = []}
    games.each do |game|
      visitor_hash[game.away_team_id] << game.away_goals.to_f
    end

    visitor_average_hash = Hash.new
    visitor_hash.each do |team_id, score_array|
      visitor_average_hash[team_id] = (score_array.sum / score_array.size).round(4)
    end

    sorted_visitor_scores = visitor_average_hash.sort_by {|key, value| value}

    find_team_name(sorted_visitor_scores.first[0])
  end

  def lowest_scoring_home_team
    home_hash = Hash.new{|k,v| k[v] = []}
    games.each do |game|
      home_hash[game.home_team_id] << game.home_goals.to_f
    end

    home_average_hash = Hash.new
    home_hash.each do |team_id, score_array|
      home_average_hash[team_id] = (score_array.sum / score_array.size).round(4)
    end

    sorted_home_scores = home_average_hash.sort_by {|key, value| value}

    find_team_name(sorted_home_scores.first.first)
  end

  def team_info(team_id)
    team = teams.find do |team|
      team.team_id == team_id
    end

    team_info = {
      "team_id" => team.team_id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.team_name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end

  def game_ids_by_season(team_id)
    seasons_game_id_hash = Hash.new{|h,v| h[v] = []}
    games.each do |game| 
      seasons_game_id_hash[game.season] << game.game_id
    end
    seasons_game_id_hash
  end

  def wins_per_season(team_id)
    wins_by_season = Hash.new{|h,v| h[v] = []}
    game_ids_by_season = game_ids_by_season(team_id)

    game_ids_by_season.each do |season, game_id_array|
      game_id_array.each do |game_id|
        game_teams.each do |game_team|
          if game_team.game_id == game_id && game_team.team_id == team_id && game_team.result == "WIN"
            wins_by_season[season] << game_team.result
          end
        end
      end
    end

    win_totals = wins_by_season.each do |season, wins_array|
      wins_by_season[season] = wins_array.size
    end
    
    win_totals.sort_by { |k, v| v }
  end

  def best_season(team_id)
    wins_per_season(team_id).last[0]
  end

  def worst_season(team_id)
    wins_per_season(team_id).first[0]
  end

  def total_games_by_team_id(team_id)
    game_teams.count do |game_team|
      game_team.team_id == team_id
    end
  end

  def average_win_percentage(team_id)
    wins = 0
    game_teams.each do |game_team|
      if game_team.team_id == team_id && game_team.result == "WIN"
        wins += 1
      end
    end
  
    (wins.to_f / total_games_by_team_id(team_id)).round(2)
  end

  def most_goals_scored(team_id)
    goals = 0
    game_teams.each do |game_team|
      if game_team.team_id == team_id && game_team.goals > goals
        goals = game_team.goals
      end
    end
    goals
  end

  def fewest_goals_scored(team_id)
    goals = 50
    game_teams.each do |game_team|
      if game_team.team_id == team_id && game_team.goals < goals
        goals = game_team.goals
      end
    end
    goals
  end

  # the #favorite_opponent is the opponent that has the lowest win percentage against the given team in the argument.
  # it is calculated by only looking at games where the argument of the given team_id was the home team.
  # it iterates through all of the games where the given team_id was the home team and then iterates through all of the game_teams
  # #favorite_opponent utilizes the several helper methods of #get_game_id_array, #opponent_match_results, and #opponents_win_percentage
  def get_game_id_array(team_id)
    all_games = game_teams.find_all { |team| team.team_id == team_id }

    all_games.map { |game| game.game_id }
  end
end