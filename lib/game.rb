class Game
  attr_reader :attempt

  # Заданный диапазон чисел - это возможные варианты ответов,
  # загаданое число изменяется в зависисмости от ответа пользователя.
  def initialize
    @min_number = 1
    @max_number = 16

    @attempt = 0
  end

  def next_attempt
    @attempt += 1
  end

  def guessed_number
    (@max_number + @min_number) / 2
  end

  def result_of_attempt(number)
    change_range_of_hidden_numbers(number)

    return if over?

    calculate_deviation(number)

    result = @deviation.abs < 3 ? 'Тепло, ' : 'Холодно, '
    result += 'нужно '
    result += @deviation < 0 ? 'меньше' : 'больше'
    result
  end

  def result_of_game
    if game.win?
      "Ура!!! Вы отгадали правильный ответ! Количество попыток: #{game.attempt}."
    else
      "Попытки закончились, вы не отгадали. Правильный ответ: #{game.guessed_number}"
    end
  end

  def over?
    win? || lose?
  end

  private

  def calculate_deviation(number)
    @deviation = guessed_number - number
  end

  # Если пользователь ввёл адекватное число, то заменяем крайнее число диапазона на это число
  # Рассмотрим идеальную игру пользователя на примере number > center_of_range:
  # 1) диапазон 1..16, пользователь ввёл 9: max-min > 3 => 1..6
  # - если диапазон возможных чисел max-min > 3 - возвращаем этот диапазон. (Холодно)
  # 2) 1..6, пользователь ввёл 4: max-min = 3 (number < max_number) => 2..3 (Тепло)
  # - возвращать 1..2 при данном подходе нельзя, так как 1 - холодно, 2 - тепло
  # 3) 2..3,
  # - пользователь ввёл 3: max-min = 1 => 2..2
  # - пользователь ввёл 4: max-min = 2 => 2..2
  # - пользователь ввёл 5: max-min = 3 (number >= max_number) => 3..3
  def change_range_of_hidden_numbers(number)
    return unless ((@min_number - 2)..(@max_number + 2)).include?(number)

    if number > guessed_number
      case number - @min_number
      when 1..2 then @max_number = @min_number
      when 3 then
        @min_number = number - 2
        @max_number = number >= @max_number ? @min_number : number - 1
      when 4.. then @max_number = number - 3
      end
    else
      case @max_number - number
      when 1..2 then @min_number = @max_number
      when 3 then
        @max_number = number + 2
        @min_number = number <= @min_number ? @max_number : number + 1
      when 4.. then @min_number = number + 3
      end
    end
  end

  def lose?
    @attempt > 2
  end

  def win?
    @deviation == 0
  end
end

