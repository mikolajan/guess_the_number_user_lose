# encoding: utf-8
#
# Программа 'Угадай число' загадывает число от 1 до 16, а пользователь пытается угадать его за 3 попытки,
# при этом программа даёт подсказку: больше/меньше и тепло(разница меньше 3)/холодно(разница больше 2)
#
# (с) Nikolay Zhurilo (@mikolajan) https://github.com/mikolajan/

require_relative 'lib/game'

game = Game.new

puts "Угадайте целое число от 1 до 16 за три попытки?"

until game.over?
  game.next_attempt

  puts "\nПопытка #{game.attempt}. Введите число:"
  user_input = gets.to_i

  puts game.result_of_attempt(user_input)
end

puts game.result_of_game
