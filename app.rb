$LOAD_PATH << '.'

puts `clear`
puts 'Welcome to the MASSIVE number tranlator'.upcase + "\n\r"
puts "Enter any number up to one hundred vigintillion to translate: \n\r"
answer = gets.chomp.gsub(/\D/,'')
require 'word_number'
require 'fixnum'
require 'bignum'
number = WordNumber.new(number: answer.to_i)
string = "Your number #{answer} in English is: \n\n" + number.to_word(answer.to_i)
puts "\n\r\033[1m**** SUCCESS!!! ****\033[0m\n\n\r"
puts  "\033[35m#{string.upcase} \033[0m\n\n\r"
