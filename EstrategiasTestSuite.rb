require "test/unit"
load "Jugadas.rb"
load "Estrategias.rb"
load "InputMocking.rb"

class EstrategiasTestSuite < Test::Unit::TestCase
    def test_manual
        inputs_para_manual = {
            "1" => Piedra,
            "2" => Papel,
            "3" => Tijeras,
            "4" => Lagarto,
            "5" => Spock
        }
        inputs_para_manual.each do |input, jugada|
            InputMocker.with_fake_input([input]) do
                manual = Manual.new()
                assert_equal(jugada, manual.prox(nil))
            end
        end
    end

end
