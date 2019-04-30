require_relative 'p04_linked_list'

class HashMap
  include Enumerable

  attr_accessor :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket = bucket(key)
    linked_list = @store[bucket]
    linked_list.include?(key)
  end

  def set(key, val)
    bucket = bucket(key)
    linked_list = @store[bucket]
    if !linked_list.include?(key)
      linked_list.append(key, val)
      @count += 1
      resize! if @count >= num_buckets
    else
      linked_list.update(key, val)
    end
    
  end

  def get(key)
    bucket = bucket(key)
    linked_list = @store[bucket]
    linked_list.get(key)
  end

  def delete(key)
    bucket = bucket(key)
    linked_list = @store[bucket]
    linked_list.remove(key)
    @count -= 1
  end

  def each
    @store.each do |linked_list|
      linked_list.each do |node|
        yield [node.key, node.val]
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    old_store = @store
    @store = Array.new(num_buckets * 2) { LinkedList.new }
    @count = 0

    old_store.each do |linked_list|
      linked_list.each do |node|
        self.set(node.key, node.val)
      end
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    new_key = key.hash
    new_key % num_buckets
  end
end
