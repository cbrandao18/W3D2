require 'byebug'

class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    self.store[i]
  end

  def []=(i, val)
    validate!(i)
    self.store[i] = val
  end

  def length
    self.store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, self.store.length - 1)
  end
end

class DynamicArray
  attr_accessor :count
  include Enumerable

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    if i.abs > capacity - 1
      #trying to access the array out of bounds
      return nil
    else
      if i < 0 #negative indexing
        i = @count - i.abs
      end

      return @store[i]
    end
  end

  def []=(i, val)
    if i >= @count
      (i - @count).times { push(nil) }
    else
      if i < 0 #negative indexing
        pos_i = i.abs
        i = @count - pos_i
      end
    end

    if i == self.count
      resize! if capacity == @count
      @count += 1
    end

    @store[i] = val
  end

  def capacity
    @store.length
  end

  def include?(val)
    self.any?{|el| el == val}
  end

  def push(val)
    i = @count
    if i > capacity - 1
      resize!
    end

    if i >= capacity || i < 0
      self.push(nil)
    else
      @store[i] = val
      @count += 1
    end
  end

  def unshift(val)
    resize! if @count == capacity - 1
    new_store = StaticArray.new(capacity)
    @store.store.each.with_index do |el, i|
      if !el.nil?
        new_store[i+1] = el
      end
    end
    new_store[0] = val
    @count += 1
    @store = new_store
  end

  def pop
    return nil if @count == 0
    val = @store[@count-1]
    @store[@count-1] = nil
    @count -= 1
    return val
  end

  def shift
    return nil if @count == 0
    val = @store[0]
    new_store = StaticArray.new(capacity)
    @store.store.each.with_index do |el, i|
      if i == 0
        next
      end
      if !el.nil?
        new_store[i-1] = el
      end
    end
    @store = new_store
    @count -= 1
    return val
  end

  def first
    @store[0]
  end

  def last
    @store[@count-1]
  end

  def each
    @count.times do |i|
      yield self[i]
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false if self.length != other.length
    self.each_with_index do |el, i|
      return false if el != other[i]
    end
    return true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_store = StaticArray.new(capacity * 2)

    @store.store.each.with_index do |el, i|
      new_store[i] = el
    end

    @store = new_store
  end
end
