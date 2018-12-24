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
        # Probamos que haga raise de ArgumentError cuando el argumento no sea una subclase
        manual = Manual.new()
        assert_raise(ArgumentError) do
            manual.prox(1)
        end
    end

end
