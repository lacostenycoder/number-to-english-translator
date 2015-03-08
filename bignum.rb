class Bignum

  def split_number
    self.to_s.split('').map{|n| n.to_i}
  end

end
