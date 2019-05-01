require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache

  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if !@map[key].nil? #already in cache, just update it's place in the linked list
      node = @map[key]
      update_node!(node)
    else #not in cache, gotta calculate
      calc!(key)
    end
  end

  def to_s
    'Map: ' + @map.to_s + '\n' + 'Store: ' + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key

    #get value by calling the prc
    value = @prc.call(key)
    #create the node with the given key and calculated value
    node = @store.append(key, value)
    #add the reference to that node to the map
    @map[key] = node

    #check if we added more than the max
    eject! if count > @max
    return value
  end

  def update_node!(node)
    # suggested helper method; move a node to the end of the list
    
    #remove it from the linked list
    @store.remove(node.key)

    #append it to the end of the linked list
    moved_node = @store.append(node.key, node.val)

    #change the map at that key to point to the node now at the end of the list
    @map[node.key] = moved_node

  end

  #Deletes the least recently used item so your LRU cache is back to max size.
  def eject!
    #removes the first node
    node = @store.first
    @store.remove(node.key)

    #get rid of the map's reference to the deleted node
    @map.delete(node.key)
  end
end