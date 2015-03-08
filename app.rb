$LOAD_PATH << '.'


puts 'Welcome to the MASSIVE number tranlator'.upcase
puts 'Enter any number up to one hundred vigintillion to translate: '
answer = gets.chomp
require 'word_number'
require 'fixnum'
require 'bignum'
number = WordNumber.new(number: answer.to_i)
STDOUT.flush
puts 'Your number #{answer} is: ' + number.to_word(answer.to_i)
