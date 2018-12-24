##
# Clase que crea stdin de mentira a partir del arreglo de strings
# que le suministre en el constructor
class InputMocker

  ##
  # Recibe el arreglo de strings que usara como stdin
  #
  # Parámetros:
  # +strings+:: [String] Arreglo de strings con el input que se le va a pasar
  def initialize(strings)
    @strings = strings
  end

  def gets # :nodoc:
    next_string = @strings.shift
    # Uncomment the following line if you'd like to see the faked $stdin#gets
    # puts "(DEBUG) Faking #gets with: #{next_string}"
    next_string
  end

  ##
  # Finje el input usando el arreglo de strings
  def self.with_fake_input(strings)
    $stdin = new(strings)
    yield
  ensure
    $stdin = STDIN
  end
end
