class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    hash = key.hash
    if !self.include?(key)
      self[hash] << key
      @count += 1
      resize! if @count > num_buckets
      return true
    end
  end

  def include?(key)
    hash = key.hash
    self[hash].include?(key)
  end

  def remove(key)
    hash = key.hash
    if self.include?(key)
      self[hash].delete(key) 
      @count -= 1
    end
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    prev_data = @store
    @count = 0
    @store = Array.new(num_buckets * 2) { Array.new }

    prev_data.each do |bucket|
      bucket.each do |el|
        @store.insert(el)
      end
    end

  end
end
