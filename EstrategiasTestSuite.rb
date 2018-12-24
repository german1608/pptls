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
                assert_instance_of(jugada, manual.prox(nil))
            end
        end
        # Probamos que haga raise de ArgumentError cuando el argumento no sea una subclase
        manual = Manual.new()
        assert_raise(ArgumentError) do
            manual.prox(1)
        end
    end

    def test_copiar
        # Probamos el initialize
        invalid_params = [Jugada, 1, "Jugada", "Tijeras"]
        invalid_params.each do |invalid_param|
            assert_raise(ArgumentError) do
                Copiar.new(invalid_param)
            end
        end

        # Probamos que responda correctamente
        jugadas = [Tijeras, Piedra, Papel, Spock, Lagarto].map { |x| x.new }
        jugadas.each do |jugada|
            puts jugada
            copiar = Copiar.new(jugada)
            # La primera jugada es suministrada como parametro al constructor
            assert_equal(jugada, copiar.prox(nil))
            # Las siguientes son lo que se pase como parametro a prox
            jugadas.each do |jugada|
                assert_equal(jugada, copiar.prox(jugada))
            end
        end
    end
end
