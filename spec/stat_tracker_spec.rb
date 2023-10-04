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
  end
end