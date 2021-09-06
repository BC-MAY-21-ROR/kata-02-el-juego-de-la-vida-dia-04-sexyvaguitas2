# frozen_string_literal: true

# El juego de la vida

# Clase celula que permite aplicar las reglas a las celulas
class Cell
  attr_accessor :status

  def initialize
    # Metodo para inicializar la celula
    @status = 'Dead'
  end

  def set_dead
    # Metodo para cambiar la celula a muerta
    @status = 'Dead'
  end

  def set_alive
    # Metodo para cambiar la celula a viva
    @status = 'Alive'
  end

  def alive?
    # Metodo para checar si la celula esta viva
    # Retorna true si lo esta y falso si no
    @status == 'Alive'
  end

  def display_character
    # Metodo para imprimir en el tablero
    if alive?
      'O'
    else
      '*'
    end
  end
end

# Clase que genera el tablero y nos permite aplicar las reglas en las celulas
class Board
  attr_accessor :grid, :rows, :columns

  def initialize
    # Incializamos los atributos que se usaran en la clase board
    # Ademas de ejecutrar los metodos en la secuencia necesaria
    @rows = 0
    @columns = 0
  end

  def generate_board
    # Metodo para generar la primera generacion
    print "Iniciando el talbero\n"
    @grid = Array.new(@rows) { Array.new(@columns) { Cell.new } }

    @rows.times do |row|
      @columns.times do |column|
        random_chance = rand(2) # 25%
        @grid[row][column].set_alive if random_chance == 1
      end
    end
  end

  def draw_board
    # Metodo para dibujar el tablero en la terminal
    @rows.times do |row|
      @columns.times do |column|
        print "#{@grid[row][column].display_character} "
      end
      print "\n"
    end
  end

  def update_board
    print "\nActualizando el tablero\n"
    # Lista de celulas vivas que se van a matar o resucitar o se mantienen vivas
    alive_cells = []
    dead_cells = []
    @rows.times do |row|
      @columns.times do |column|
        cells_checker(row, column, alive_cells, dead_cells)
      end
    end
    kill_or_revive(alive_cells, dead_cells)
  end

  def cells_checker(row, column, alive_cells, dead_cells)
    # Checamos la celula actual y su estado
    cell_object = @grid[row][column]
    status_maincell = cell_object.alive?
    # Checamos los vecinos de la celula actual y su estado
    check_neighbour = self.check_neighbour(row, column)
    living_neighbourscount = []
    alive_neighbours(check_neighbour, living_neighbourscount)
    status_maincells(status_maincell, living_neighbourscount, dead_cells, alive_cells, cell_object)
  end

  def alive_neighbours(check_neighbour, living_neighbourscount)
    check_neighbour.each do |neighbour_cell|
      living_neighbourscount.push(neighbour_cell) if neighbour_cell.alive?
    end
  end

  def status_maincells(status_maincell, living_neighbourscount, dead_cells, alive_cells, cell_object)
    # Si la celula actual esta viva, checa el estado de los vecinos
    if status_maincell
      game_rules(living_neighbourscount, dead_cells, alive_cells, cell_object)
    elsif living_neighbourscount.length == 3
      alive_cells.push(cell_object)
    end
  end

  def game_rules(living_neighbourscount, dead_cells, alive_cells, cell_object)
    # Revisa cuantos vecinos vivos tiene para aplicar la regla.
    if (living_neighbourscount.length < 2) || (living_neighbourscount.length > 3)
      dead_cells.push(cell_object)
    elsif (living_neighbourscount.length == 3) || (living_neighbourscount.length == 2)
      alive_cells.push(cell_object)
    end
  end

  def kill_or_revive(alive_cells, dead_cells)
    alive_cells.each(&:set_alive)
    dead_cells.each(&:set_dead)
  end

  def check_neighbour(check_row, check_column)
    # Metodo para checar todos los vecinos de todas las celulas
    search_min = -1
    search_max = 1
    neighbour_list = []
    check_near_cells(search_min, search_max, neighbour_list, check_row, check_column)
    neighbour_list
  end

  def check_near_cells(search_min, search_max, neighbour_list, check_row, check_column)
    (search_min..search_max).each do |i|
      (search_min..search_max).each do |j|
        neighbour_row = check_row + i
        neighbour_column = check_column + j
        validate_neighbour(neighbour_row, neighbour_column, check_row, check_column, neighbour_list)
      end
    end
  end

  def validate_neighbour(neighbour_row, neighbour_column, check_row, check_column, neighbour_list)
    valid_neighbour = true
    if (neighbour_row == check_row) && (neighbour_column == check_column)
      valid_neighbour = false
    elsif neighbour_row.negative? || (neighbour_row >= @rows) || (neighbour_column >= @columns)
      valid_neighbour = false
    end
    neighbour_list.push(@grid[neighbour_row][neighbour_column]) if valid_neighbour
  end
end

board1 = Board.new

while board1.rows <= 1
  print "Filas:\n"
  board1.rows = gets.to_i
end
while board1.columns <= 1
  print "Columnas:\n"
  board1.columns = gets.to_i
end

board1.generate_board
board1.draw_board

counter = 1
print "\nPresione 1 para continuar:"
i = gets.to_i
while i == 1
  counter += 1
  board1.update_board
  puts "\nGeneracion #{counter}"
  board1.draw_board
  print "\nPresione 1 para continuar:"
  i = gets.to_i
end
