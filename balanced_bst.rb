class Node
  attr_accessor :data, :left, :right
  def initialize(data=nil, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_accessor :root
  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array)
  end

  def build_tree(array)
    length = array.length
    mid = (length / 2).floor

    if length == 1
      Node.new(array[0])
    elsif length == 2
      Node.new(array[1], build_tree([array[0]]))
    elsif length.even?
      Node.new(array[mid], build_tree(array.slice(0, mid)), build_tree(array.slice(mid + 1, mid - 1)))
    else
      Node.new(array[mid], build_tree(array.slice(0, mid)), build_tree(array.slice(mid + 1, mid)))
    end
  end

  def insert(num)
    current_node = @root
    found = false
    until found == true
      if current_node.right.nil? && (num > current_node.data)
        current_node.right = Node.new(num)
        found = true
      elsif current_node.left.nil? && (num < current_node.data)
        current_node.left = Node.new(num)
        found = true
      elsif num < current_node.data
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end
  end

  def delete(num)
    current_node = @root
    if current_node.data == num
    delete_node = current_node
      if delete_node.left.nil? && delete_node.right.nil? ## delete leaf
        current_node.left = nil
      elsif delete_node.left.nil? && !delete_node.right.nil? ## only right child
        current_node.left = delete_node.right
      elsif !delete_node.left.nil? && delete_node.right.nil? ## only left child
        current_node.left = delete_node.left
      else ## has left and right children
        replacement_node = delete_node.right
        until replacement_node.left.nil?
          replacement_node = replacement_node.left
        end
        delete(replacement_node.data)
        delete_node.data = replacement_node.data
      end
      @root = delete_node
    else
      found = false
      until found == true
        if !current_node.left.nil? && current_node.left.data == num ## delete left node
          delete_node = current_node.left
          if delete_node.left.nil? && delete_node.right.nil? ## delete leaf
            current_node.left = nil
            found = true
          elsif delete_node.left.nil? && !delete_node.right.nil? ## only right child
            current_node.left = delete_node.right
            found = true
          elsif !delete_node.left.nil? && delete_node.right.nil? ## only left child
            current_node.left = delete_node.left
            found = true
          else ## has left and right children
            replacement_node = delete_node.right
            until replacement_node.left.nil?
              replacement_node = replacement_node.left
            end
            delete(replacement_node.data)
            delete_node.data = replacement_node.data
            found = true
          end
        elsif !current_node.right.nil? && current_node.right.data == num
          delete_node = current_node.right
          if delete_node.left.nil? && delete_node.right.nil? ## delete leaf
            current_node.right = nil
            found = true
          elsif delete_node.left.nil? && !delete_node.right.nil? ## only right child
            current_node.right = delete_node.right
            found = true
          elsif !delete_node.left.nil? && delete_node.right.nil? ## only left child
            current_node.right = delete_node.left
            found = true
          else ## has left and right children
            replacement_node = delete_node.left
            until replacement_node.right.nil?
              replacement_node = replacement_node.right
            end
            delete(replacement_node.data)
            delete_node.data = replacement_node.data
            found = true
          end
        elsif num < current_node.data
          current_node = current_node.left
        else
          current_node = current_node.right
        end
      end
    end
  end

  def find(num)
    current_node = @root
    found = false
    until found == true
      if current_node.data == num
        found = true
      elsif current_node.data > num
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end
    current_node
  end

  def level_order
    queue = [@root]
    result = []
    until queue.empty?
      result.push(queue[0].data)
      if !queue[0].left.nil?
        queue.push(queue[0].left)
      end
      if !queue[0].right.nil?
        queue.push(queue[0].right)
      end
      queue.shift
    end
    result
  end

  def inorder(node)
    result = []
    if node.right.nil? && node.left.nil?
      result = (result.push(node.data))
    elsif node.right.nil? && !node.left.nil?
      result = (result.push(node.data) + inorder(node.left))
    elsif node.left.nil? && !node.right.nil?
      result = (result.push(node.data) + inorder(node.right))
    else
      result = (inorder(node.left) + result.push(node.data) + inorder(node.right))
    end
    result
  end

  def preorder(node)
    result = []
    if node.right.nil? && node.left.nil?
      result = (result.push(node.data))
    elsif node.right.nil? && !node.left.nil?
      result = (result.push(node.data) + preorder(node.left))
    elsif node.left.nil? && !node.right.nil?
      result = (result.push(node.data) + preorder(node.right))
    else
      result = result.push(node.data) + (preorder(node.left) + preorder(node.right))
    end
    result
  end

  def postorder(node)
    result = []
    if node.right.nil? && node.left.nil?
      result = (result.push(node.data))
    elsif node.right.nil? && !node.left.nil?
      result = (result.push(node.data) + postorder(node.left))
    elsif node.left.nil? && !node.right.nil?
      result = (result.push(node.data) + postorder(node.right))
    else
      result = (postorder(node.left) + postorder(node.right) + result.push(node.data))
    end
    result
  end

  def height(num)
    node = find(num)
    height = 0
    if node.right.nil? && node.left.nil?
      height = 0
    else
      if node.right.nil? && !node.left.nil?
        height += 1
        height += height(node.left.data)
      elsif node.left.nil? && !node.right.nil?
        height += 1
        height += height(node.right.data)
      elsif height(node.right.data) > height(node.left.data)
        height = 1
        height += height(node.right.data)
      else
        height = 1
        height += height(node.left.data)
      end
    end
    height
  end

  def depth(num)
    current_node = @root
    depth = 0
    found = false
    until found == true
      if current_node.data == num
        found = true
      elsif current_node.data > num
        current_node = current_node.left
        depth += 1
      else
        current_node = current_node.right
        depth += 1
      end
    end
    depth
  end

  def balanced?
    if height(@root.left.data) - height(@root.right.data) > 1 || height(@root.right.data) - height(@root.left.data) > 1
      false
    else
      true
    end
  end

  def rebalance
    array = preorder(@root).sort
    @root = build_tree(array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data.to_s}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
print tree.balanced?, "\n"
print tree.level_order, "\n"
print tree.preorder(tree.root), "\n"
print tree.postorder(tree.root), "\n"
print tree.inorder(tree.root), "\n"
tree.insert(1000)
tree.insert(1001)
tree.pretty_print
tree.rebalance
tree.pretty_print
print tree.balanced?, "\n"
print tree.level_order, "\n"
print tree.preorder(tree.root), "\n"
print tree.postorder(tree.root), "\n"
print tree.inorder(tree.root), "\n"
