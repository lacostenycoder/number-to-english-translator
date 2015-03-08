require 'pry'

class WordNumber

  NUMBER_WORDS = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
  DELINEATOR = ['thousand','million','billion','trillion','quadrillion','quintillion','sextillion','septillion','octillion','nonillion','decillion','undecillion','duodecillion','tredecillion','quattuordecillion','quindecillion','sexdecillion','septendecillion','octodecillion','novemdecillion','vigintillion']
  attr_accessor :number

  def initialize(number)
    @number = number
  end

  def to_word(*num)
    words = []
    if num.any?
      digits = num.first.split_number
    else
      digits = self.number.split_number
    end
    digits.each.with_index do |n, index|
      words << convert_digit(n)
    end
    if words.length == 2
      words = two_digits(words)
      if words[1] == 'zero'
        return words[0]
      end
      return words.join(' ')
    end
    three_groups = words.reverse.each_slice(3).to_a.map{|a|a.reverse}.reverse
    three_groups = three_groups.map do |group|
      if group.length == 2
        two_group = two_digits(group, num)
      end
      if two_group
        group = two_group
      else
        group = word_replacer(group)
        group = teen_fix(group)
      end
    end
    words = words_maker(three_groups)
    words.slice!'zero hundred '
    words.slice!'zero hundred'
    if words.length > 6
      if words[-4..words.length].include?('and')
        words = words[0..-5]
      end
    end
    return words
  end

  def two_digits(words, *num)
    if num.any?
      num.reject! { |c| c.empty? }
      num.reject! { |c| c.empty? }
    end
    if num.any?
      num = num.first.first
    else
      # rescue block because of incosistent method call in rspec vs app
      begin
        num = self.number.first.last
      rescue
        num = self.number
      end
    end
    if num == 10
      return ['ten']
    end
    if num < 20
      group = teen words[1]
    else
      group = ty(words[0]) + ' ' + words[1]
    end
    group.split(' ')
  end

  def words_maker(words_arr)
    words_arr = words_arr.map{|group| hundred(group)}
    words_arr = zero_clean(words_arr)
    if words_arr.length >= 2
      del = words_arr.count-2
      del = DELINEATOR[0..del].reverse
      words_arr.each.with_index do |group, index|
        append_delineator = del[index]
        group << append_delineator if append_delineator
      end
    end
    word = words_arr.join(' ')
    word = hundred_fix(word) if word.split(' ').last == 'hundred'
    return word
  end

  def hundred_fix(word)
    if self.number.to_s[-3,3] == '000'
      word = word.split(' ')
      word.pop
    else
      if self.number.class == Hash
        length = self.number.first.last.to_s.length
      else
        length = self.number.to_s.length
      end
      if length >= 6
        deliniate = DELINEATOR[length/3-2]
      elsif length > 3
        deliniate = DELINEATOR[length-2]
      else
        deliniate == nil
      end

      if self.number.class == Hash
        num = self.number.first.last
      else
        num = self.number
      end

      if num > 10000
        last_three = self.number.to_s[-3,3].to_i
        last_3 = WordNumber.new(number: last_three)
        num = last_3.number.first.last
        last_three_word = last_3.to_word(num)
      end
      word += ' ' + deliniate if deliniate
      word += ' and ' + last_three_word if last_three_word
      return word
    end
    word = word.join(' ')
    return word
  end

  def zero_clean(words_arr)
    if self.number == 0
      return 'zero'
    else
      new_arr = []
      words_arr = words_arr.each do |group|
        group.pop if group.last == 'zero'
        if group[0] == 'zero' && group[1] == 'hundred'
          group = group[2..group.length]
        end
        if group.include?('hundred')
          group = group.reject{|n|n.include?('zero')}
          if group.last == 'and'
            new_arr << group.reject{|w| w == 'and'}
          end
          new_arr = new_arr.reject{|w| w.include?('zero')}
        end
      end
    end
    if new_arr.any?
      return new_arr
    else
      return words_arr
    end
  end

  def hundred(group)
    return if !group
    return ['ten'] if group == 'ten'
    if group.length == 3
      group.insert(1, 'hundred', 'and')
    end
    return group.compact
  end

  def teen_fix(words)
    if words.length > 2
      if ['eleven','twelve'].include?(words[1])
        words[1] = nil
        replace = self.teen(words[2])
        words[2] = replace
      end
    end
    return words
  end

  def word_replacer(words)
    words = words.map.with_index do |w, index|
      if index == 1
        if w == 'one'
          w = suffix(w, 'teen')
        else
          w = suffix(w, 'ten')
        end
      else
        w
      end
    end
    if words.count == 2 && words[0] == 'one' && !words[1]
      return 'ten'
    else
      return words
    end
  end

  def convert_digit(num, *arg)
    return NUMBER_WORDS[num]
  end

  def suffix(word, type)
    return word if type == 'one'
    case type
    when 'teen'
      word = teen(word)
    when 'ten'
      word = ty(word)
    end
    return word
  end

  def teen(word)
    case word
    when 'one'
      word = 'eleven'
    when 'two'
      word = 'twelve'
    when 'three'
      word = 'thirteen'
    when 'five'
      word = 'fifteen'
    when 'eight'
      word = 'eighteen'
    else
      word += 'teen'
    end
    return word
  end

  def ty(word)
    case word
    when 'zero'
      word = nil
    when 'one'
      word = 'ten'
    when 'two'
      word = 'twenty'
    when 'three'
      word = 'thirty'
    when 'four'
      word = 'forty'
    when 'five'
      word = 'fifty'
    when 'eight'
      word = 'eighty'
    else
      word += 'ty'
    end
    return word
  end

end
