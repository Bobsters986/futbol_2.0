require './lib/stat_tracker'

describe StatTracker do

  let(:game_path){'./data/games.csv'}
  let(:team_path){'./data/teams.csv'}
  let(:game_teams_path){'./data/game_teams.csv'}
  
  let(:locations){{
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }}

  let(:stat_tracker){StatTracker.from_csv(locations)}

  describe 'instantiation' do
    it 'exists' do
      expect(stat_tracker).to be_a(StatTracker)
    end

    it 'creates arrays for each CSV file' do
      expect(stat_tracker.games).to be_an(Array)
      expect(stat_tracker.teams).to be_an(Array)
      expect(stat_tracker.game_teams).to be_an(Array)
    end

    it 'creates a game objects array with game attributes' do
      expect(stat_tracker.games.first).to be_a(Game)
      expect(stat_tracker.games.first.game_id).to eq("2012030221")
      expect(stat_tracker.games.first.season).to eq("20122013")
      expect(stat_tracker.games.first.type).to eq("Postseason")
      expect(stat_tracker.games.first.date_time).to eq("5/16/13")
      expect(stat_tracker.games.first.away_team_id).to eq("3")
      expect(stat_tracker.games.first.home_team_id).to eq("6")
      expect(stat_tracker.games.first.away_goals).to eq(2)
      expect(stat_tracker.games.first.home_goals).to eq(3)
      expect(stat_tracker.games.first.venue).to eq("Toyota Stadium")
      expect(stat_tracker.games.first.venue_link).to eq("/api/v1/venues/null")
    end

    it 'creates a team objects array with team attributes' do
      expect(stat_tracker.teams.first).to be_a(Team)
      expect(stat_tracker.teams.first.team_id).to eq("1")
      expect(stat_tracker.teams.first.franchise_id).to eq("23")
      expect(stat_tracker.teams.first.team_name).to eq("Atlanta United")
      expect(stat_tracker.teams.first.abbreviation).to eq("ATL")
      expect(stat_tracker.teams.first.stadium).to eq("Mercedes-Benz Stadium")
      expect(stat_tracker.teams.first.link).to eq("/api/v1/teams/1")
    end

    it 'creates a game_team objects array with game_team attributes' do
      expect(stat_tracker.game_teams.first).to be_a(GameTeam)
      expect(stat_tracker.game_teams.first.game_id).to eq("2012030221")
      expect(stat_tracker.game_teams.first.team_id).to eq("3")
      expect(stat_tracker.game_teams.first.hoa).to eq("away")
      expect(stat_tracker.game_teams.first.result).to eq("LOSS")
      expect(stat_tracker.game_teams.first.settled_in).to eq("OT")
      expect(stat_tracker.game_teams.first.head_coach).to eq("John Tortorella")
      expect(stat_tracker.game_teams.first.goals).to eq(2)
      expect(stat_tracker.game_teams.first.shots).to eq(8)
      expect(stat_tracker.game_teams.first.tackles).to eq(44)
      expect(stat_tracker.game_teams.first.pim).to eq(8)
      expect(stat_tracker.game_teams.first.power_play_opportunities).to eq(3)
      expect(stat_tracker.game_teams.first.power_play_goals).to eq(0)
      expect(stat_tracker.game_teams.first.face_off_win_percentage).to eq(44.8)
      expect(stat_tracker.game_teams.first.giveaways).to eq(17)
      expect(stat_tracker.game_teams.first.takeaways).to eq(7)
    end
  end

  describe 'instance methods' do
    it 'returns the #highest_total_score' do
      expect(stat_tracker.highest_total_score).to eq(11)
    end

    it 'returns the #lowest_total_score' do
      expect(stat_tracker.lowest_total_score).to eq(0)
    end

    it 'returns the #percentage_home_wins' do
      expect(stat_tracker.percentage_home_wins).to eq(0.44)
    end

    it 'returns the #percentage_away_wins' do
      expect(stat_tracker.percentage_visitor_wins).to eq(0.36)
    end

    it 'returns the #percentage_ties' do
      expect(stat_tracker.percentage_ties).to eq(0.20)
    end

    it "can #count_of_games_by_season" do
      expected = {
        "20122013"=>806,
        "20162017"=>1317,
        "20142015"=>1319,
        "20152016"=>1321,
        "20132014"=>1323,
        "20172018"=>1355
      }
      expect(stat_tracker.count_of_games_by_season).to eq expected
    end

    it "can return #average_goals_per_game" do
      expect(stat_tracker.average_goals_per_game).to eq 4.22
    end

    it "#average_goals_by_season" do
      expected = {
        "20122013"=>4.12,
        "20162017"=>4.23,
        "20142015"=>4.14,
        "20152016"=>4.16,
        "20132014"=>4.19,
        "20172018"=>4.44
      }
      expect(stat_tracker.average_goals_by_season).to eq expected
    end

    it "can return #count_of_teams" do
      expect(stat_tracker.count_of_teams).to eq(32)
    end

    it 'can #find_team_name by team_id' do
      expect(stat_tracker.find_team_name("2")).to eq("Seattle Sounders FC")
    end

    it "can return a #team_score_averages array" do
      expected = [["7", 1.8362],
      ["53", 1.8902],
      ["1", 1.9352],
      ["23", 1.9722],
      ["27", 2.0231],
      ["4", 2.0377],
      ["12", 2.0437],
      ["8", 2.0462],
      ["22", 2.0467],
      ["13", 2.0582],
      ["17", 2.0593],
      ["21", 2.0658],
      ["20", 2.0677],
      ["26", 2.0841],
      ["9", 2.1055],
      ["19", 2.1065],
      ["10", 2.1067],
      ["30", 2.1155],
      ["3", 2.1262],
      ["18", 2.1462],
      ["16", 2.1648],
      ["29", 2.1663],
      ["52", 2.1733],
      ["2", 2.1846],
      ["28", 2.186],
      ["24", 2.1954],
      ["15", 2.2121],
      ["14", 2.2203],
      ["25", 2.2243],
      ["6", 2.2627],
      ["5", 2.2862],
      ["54", 2.3431]]

      expect(stat_tracker.team_score_averages).to eq expected
    end
  
    it "can return #best_offense" do
      expect(stat_tracker.best_offense).to eq("Reign FC")
    end

    it "can return #worst_offense" do
      expect(stat_tracker.worst_offense).to eq("Utah Royals FC")
    end

    it "can return #highest_scoring_visitor" do
      expect(stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
    end

    it "can return #highest_scoring_home_team" do
      expect(stat_tracker.highest_scoring_home_team).to eq("Reign FC")
    end

    it "can return #lowest_scoring_visitor" do
      expect(stat_tracker.lowest_scoring_visitor).to eq("San Jose Earthquakes")
    end

    it "can return #lowest_scoring_home_team" do
      expect(stat_tracker.lowest_scoring_home_team).to eq("Utah Royals FC")
    end

    it "can give #team_info by team_id" do
      expected = {
        "team_id"=>"1",
        "franchise_id"=>"23",
        "team_name"=>"Atlanta United",
        "abbreviation"=>"ATL",
        "link"=>"/api/v1/teams/1"
      }

      expect(stat_tracker.team_info("1")).to eq expected
    end

    it "can return a teams #wins_per_season by team_id" do
      expected =  [
        ["20142015", 31], 
        ["20152016", 33], 
        ["20122013", 38], 
        ["20162017", 45], 
        ["20172018", 50], 
        ["20132014", 54]
      ]

      expect(stat_tracker.wins_per_season("6")).to eq expected
    end

    it "can return #best_season by team_id" do
      expect(stat_tracker.best_season("6")).to eq("20132014")
    end

    it "can return #worst_season by team_id" do
      expect(stat_tracker.worst_season("6")).to eq("20142015")
    end

    it "can return the #total_games_by_team_id" do
      expect(stat_tracker.total_games_by_team_id("6")).to eq(510)
    end

    it "can return #average_win_percentage by team_id" do
      expect(stat_tracker.average_win_percentage("6")).to eq(0.49)
    end

    it "can return #most_goals_scored by team_id" do
      expect(stat_tracker.most_goals_scored("18")).to eq(7)
    end

    it "can return #fewest_goals_scored by team_id" do
      expect(stat_tracker.fewest_goals_scored("18")).to eq(0)
    end

    it "can #get_game_id_array by team_id for a specific team" do
      expect(stat_tracker.get_game_id_array("18").size).to eq(513)
    end

    it "can return #opponent_match_results hash of wins and losses by team_id" do
      expect(stat_tracker.opponent_match_results("18")).to be_a(Hash)
      expect(stat_tracker.opponent_match_results("18").size).to eq(31)
    end

    it " can return an array of #opponents_win_percentage vs the team_id provided" do
      expected = [["14", 0.0],
      ["9", 0.2],
      ["4", 0.2],
      ["22", 0.22],
      ["53", 0.25],
      ["24", 0.26],
      ["3", 0.3],
      ["6", 0.3],
      ["7", 0.3],
      ["8", 0.3],
      ["27", 0.33],
      ["54", 0.33],
      ["16", 0.37],
      ["25", 0.37],
      ["21", 0.38],
      ["23", 0.39],
      ["20", 0.39],
      ["29", 0.4],
      ["1", 0.4],
      ["12", 0.4],
      ["2", 0.4],
      ["30", 0.41],
      ["28", 0.44],
      ["19", 0.44],
      ["26", 0.44],
      ["52", 0.45],
      ["10", 0.5],
      ["15", 0.5],
      ["5", 0.56],
      ["13", 0.6],
      ["17", 0.64]]

      expect(stat_tracker.opponents_win_percentage("18")).to be_an(Array)
      expect(stat_tracker.opponents_win_percentage("18").size).to eq(31)
      expect(stat_tracker.opponents_win_percentage("18")).to eq expected
    end

    it "can return #favorite_opponent by team_id" do
      expect(stat_tracker.favorite_opponent("18")).to eq("DC United")
    end

    it "can return #rival by team_id" do
      expect(stat_tracker.rival("18")).to eq("Houston Dash").or eq("LA Galaxy")
    end

    it "can return an #array_of_gameids_by_season" do
      expect(stat_tracker.array_of_gameids_by_season("20142015")).to be_an(Array)
      expect(stat_tracker.array_of_gameids_by_season("20142015").size).to eq(1319)
    end

    it "can return an #array_of_game_teams_by_season" do
      expect(stat_tracker.array_of_game_teams_by_season("20142015")).to be_an(Array)
      expect(stat_tracker.array_of_game_teams_by_season("20142015").first).to be_a(GameTeam)
      expect(stat_tracker.array_of_game_teams_by_season("20142015").size).to eq(2638)
    end

    it "can return #coach_win_percentage by season_id" do
      expect(stat_tracker.coach_win_percentage("20142015")).to be_a(Hash)
      expect(stat_tracker.coach_win_percentage("20142015").size).to eq(35)
      expect(stat_tracker.coach_win_percentage("20142015").first[0]).to be_a(String)
      expect(stat_tracker.coach_win_percentage("20142015").first[1]).to be_a(Float)
    end

    it "can return winningest_coach by season_id" do
      expect(stat_tracker.winningest_coach("20132014")).to eq("Claude Julien")
      expect(stat_tracker.winningest_coach("20142015")).to eq("Alain Vigneault")
    end

    it "can return worst_coach by season_id" do
      expect(stat_tracker.worst_coach("20132014")).to eq("Peter Laviolette")
      expect(stat_tracker.worst_coach("20142015")).to eq("Craig MacTavish").or(eq("Ted Nolan"))
    end

    it "can return #most_accurate_team by season_id" do
      expect(stat_tracker.most_accurate_team("20132014")).to eq("Real Salt Lake")
      expect(stat_tracker.most_accurate_team("20142015")).to eq("Toronto FC")
    end

    it "can return #least_accurate_team by season_id" do
      expect(stat_tracker.least_accurate_team("20132014")).to eq("New York City FC")
      expect(stat_tracker.least_accurate_team("20142015")).to eq("Columbus Crew SC")
    end

    it "can return #most_tackles by season_id" do
      expect(stat_tracker.most_tackles("20132014")).to eq("FC Cincinnati")
      expect(stat_tracker.most_tackles("20142015")).to eq("Seattle Sounders FC")
    end
  end
end