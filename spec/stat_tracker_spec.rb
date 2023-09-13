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