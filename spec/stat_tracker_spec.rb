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

    it 'has attributes' do
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
  end

  describe 'instance methods' do
    describe '#highest_total_score' do
      it 'returns the highest total score' do
        expect(stat_tracker.highest_total_score).to eq(11)
      end
    end

    describe '#lowest_total_score' do
      it 'returns the lowest total score' do
        expect(stat_tracker.lowest_total_score).to eq(0)
      end
    end
  end
end