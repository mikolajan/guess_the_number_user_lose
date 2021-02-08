require 'game'

describe Game do
    GAME_TESTS = {
      [9,4,3] => 2,
      [9,4,2] => 3,
      [8,13,14] => 15,
      [8,13,15] => 14
    }

  let(:game) { described_class.new }

  describe 'GAME' do
    GAME_TESTS.each do |user_inputs, guessed_number|
      it "returns guessed_number #{guessed_number}" do
        user_inputs.each { |user_input| game.result_of_attempt(user_input) }

        expect(game.over?).to be_truthy
        expect(game.send(:guessed_number)).to eq guessed_number
      end
    end
  end

  describe '#result_of_attempt(number)' do
    context 'check of attempt_counter' do
      it 'attempts must increase' do
        3.times do |i|
          expect(game.attempt_counter).to eq i + 1

          game.result_of_attempt(5)
        end

        expect(game.attempt_counter).to eq 4
      end
    end

    describe 'change min and max numbers' do
      context 'min and max numbers do not change' do
        it "input_number more by 3 than max_number" do
          game.result_of_attempt(19)

          expect(game.instance_variable_get(:@max_number)).to be 16
        end

        it "input_number less by 3 than min_number" do
          game.instance_variable_set(:@min_number, 12)

          game.result_of_attempt(9)

          expect(game.instance_variable_get(:@min_number)).to be 12
        end
      end

      context 'change min and max numbers if deviation > 3' do
        it "change max_number if deviation > 0" do
          [9, 5].each do |num|
            game.result_of_attempt(num)

            expect(game.instance_variable_get(:@max_number)).to be num - 3
          end
        end

        it "change min_number if deviation < 0" do
          [8, 12].each do |num|
            game.result_of_attempt(num)

            expect(game.instance_variable_get(:@min_number)).to be num + 3
          end
        end
      end

      context 'change min and max numbers if deviation = 3' do
        it "change min and max numbers if deviation < 0" do
          game.instance_variable_set(:@max_number, 6)

          game.result_of_attempt(4)

          expect(game.instance_variable_get(:@max_number)).to be 3
          expect(game.instance_variable_get(:@min_number)).to be 2
        end

        it "change min and max numbers if deviation > 0" do
          game.instance_variable_set(:@max_number, 6)

          game.result_of_attempt(3)

          expect(game.instance_variable_get(:@max_number)).to be 5
          expect(game.instance_variable_get(:@min_number)).to be 4
        end
      end

      context 'change min and max numbers if deviation = 2' do
        it "change min_number if deviation > 0" do
          game.instance_variable_set(:@min_number, 13)

          game.result_of_attempt(14)

          expect(game.instance_variable_get(:@max_number)).to be 16
          expect(game.instance_variable_get(:@min_number)).to be 16
        end

        it "change max_number if deviation < 0" do
          game.instance_variable_set(:@min_number, 13)

          game.result_of_attempt(15)

          expect(game.instance_variable_get(:@max_number)).to be 13
          expect(game.instance_variable_get(:@min_number)).to be 13
        end
      end

      context 'change min and max numbers if deviation = 1' do
        it "change min_number if deviation < 0" do
          game.instance_variable_set(:@min_number, 15)

          game.result_of_attempt(15)

          expect(game.instance_variable_get(:@max_number)).to be 16
          expect(game.instance_variable_get(:@min_number)).to be 16
        end

        it "change max_number if deviation > 0" do
          game.instance_variable_set(:@min_number, 15)

          game.result_of_attempt(16)

          expect(game.instance_variable_get(:@max_number)).to be 15
          expect(game.instance_variable_get(:@min_number)).to be 15
        end
      end
    end
  end
end
