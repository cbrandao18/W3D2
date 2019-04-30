class Integer
  # Integer#hash already implemented for you
end

class Array
  def hash
    #iterate through array with index because ordering of the array matters
    big_hash = 0
    self.each.with_index do |el, i|
      #get the hash of the el by calling el.hash (assuming el is an integer)
      #concat it to the i.hash
      #concat all that to an overall hash 
      curr_hash = el.hash ^ i.hash
      big_hash += curr_hash
    end
    big_hash
  end
end

class String
  def hash
    alph = ("a".."z").to_a
    big_hash = 0
    self.chars.each.with_index do |char, i|
      curr_hash = alph.find_index(char).hash ^ i.hash
      big_hash += curr_hash
    end
    big_hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    big_hash = 0
    self.each do |k, v|
      curr_hash = k.hash ^ v.hash
      big_hash += curr_hash
    end
    big_hash
  end
end
