class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
  end
end

class LinkedList
  include Enumerable

  attr_reader :head, :tail

  def initialize
    @head = Node.new()
    @tail = Node.new()
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    self.empty? ? nil : @head.next
  end

  def last
    self.empty? ? nil : @tail.prev
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    self.each do |node|
      if node.key == key
        return node.val
      end
    end
    return nil
  end

  def include?(key)
    self.any?{ |node| node.key == key}
  end

  #[head, second_to_last, tail]
  #inserting new_node
  #[head, second_to_last, new_node, tail]
  def append(key, val)
    #create new node to add
    new_node = Node.new(key, val)
    
    ### Altering the existing nodes next and last references ####
    second_to_last = @tail.prev
    second_to_last.next = new_node
    @tail.prev = new_node

    ### Setting the new nodes references ###
    new_node.prev = second_to_last
    new_node.next = @tail

  end

  def update(key, val)
    self.each do |node|
      if node.key == key
        node.val = val
      end
    end
  end

  def remove(key)
    if self.include?(key)
      self.each do |node|
        if node.key == key #found the node to remove
          #get the nodes around the node to remove
          prev_node = node.prev
          next_node = node.next

          #re-assigns the nodes around removed node to connect to each other
          #instead of the removed node
          prev_node.next = next_node
          next_node.prev = prev_node
        end
      end
    end
  end

  def each
    curr_node = @head.next
    while curr_node != @tail
      yield curr_node
      curr_node = curr_node.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
