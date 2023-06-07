class Node
  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :arr
  def initialize(arr)
    @arr = arr
  end

  def buildtree
    new_arr = arr.dup
    new_arr.sort!
    root = build_subtree(new_arr)
    return root
  end

  def build_subtree(arr)
    return nil if arr.empty?
    mid = arr.length / 2
    root = Node.new(arr[mid])
    root.left = build_subtree(arr[0...mid])
    root.right = build_subtree(arr[mid+1..-1])
    return root
  end

  def search(root,elem)
    if root.nil? || root.data == elem
      return root
    elsif root.data < elem
      return search(root.right, elem)
    elsif root.data > elem
      return search(root.left,elem)
    end
  end

  def level_order(root)
    return [] if root.nil?
  
    queue = [root]  # Initialize the queue with the root node
    result = []     # Initialize an array to store the node values
  
    while !queue.empty?
      node = queue.shift  # Remove the first node from the queue
  
      yield node if block_given?  # Yield the node to the block if provided
  
      result << node.data  # Add the node value to the result array
  
      # Enqueue the child nodes (left and right) if they exist
      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
    end
  
    result  # Return the result array if no block is given
  end

  
  def insert(root,elem)
    if root.nil?
      return Node.new(elem)
    elsif root.data < elem
      root.right = insert(root.right,elem)
    elsif root.data > elem
      root.left = insert(root.left,elem)
    end
    return root
  end

  def delete_node(root,key)
#base case,that deletes the node
    if root.nil?
      return root
#Next is to locate the node to be deleted in either left or right of the root
    elsif key < root.data
      root.left = delete_node(root.left,key)
      return root
    elsif key > root.data
      root.right = delete_node(root.right,key)
      return root
    else
      if root.left.nil?
        return root.right
      elsif root.right.nil?
        return root.left
      end
#Below code deletes the node having both children
#The logic is when we have a node with 2 children we can either replace the root node to be deleted with the minimum node in the right subtree or with the minimum node in the left subtree
#For the purpose of this code we will do the recursive deletion in the right subtree when such a case occurs
      succ = find_min(root.right)
      root.data = succ.data
      root.right = delete_node(root.right,succ.data)
    end
    return root
  end

  def find_min(node)
    current = node
    current = current.left until current.left.nil?
    current
  end


  def find(root,val)
    if root.nil?
      return nil
    end

    if root.data == val
      return root.data
    end
    
    if val < root.data
      root.left = find(root.left,val)
    elsif val > root.data
      root.right = find(root.right,val)
    end
  end
    
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def preorder(root,&block)
   return [] if root.nil?
   ans = []
   block_given? ? yield(root.data) : ans << root.data
   ans += preorder(root.left, &block)
   ans += preorder(root.right, &block)
   ans 
  end

  def inorder(root,&block)
    return [] if !root
    ans = []
    ans += inorder(root.left, &block)
    block_given? ? yield(root.data) : ans << root.data
    ans += inorder(root.right, &block)
    ans
  end

  def postorder(root,&block)
    return [] if !root
    ans = []
    ans += postorder(root.left, &block)
    ans += postorder(root.right, &block)
    block_given? ? yield(root.data) : ans << root.data
    ans
  end

  def find_height(root)
    if root.nil?
      return -1
    end
    left_height = find_height(root.left)
    right_height = find_height(root.right)
    max(left_height,right_height) + 1
  end

  def find_depth(root,val)
    return -1 if root.nil?
    dist = -1

    if root.data == val || (dist = find_depth(root.left,val)) >= 0 || (dist = find_depth(root.right,val)) >= 0
      return dist + 1
    end

    return dist
  end
    
  def max (a,b)
    a>b ? a : b
  end

  def is_balanced?(root)
    if root.nil?
      return true
    end

    lh = find_height(root.left)
    rh = find_height(root.right)

    if (lh-rh > 1) || (lh - rh < -1)
      return false
    end
    
    return true
  end

  def rebalance(root)
    @lst = inorder(root)
    build_bst(0,@lst.size - 1)
  end

  def build_bst(low, high)
    return nil  if low > high
    mid = low + (high - low) / 2
    node = Node.new(@lst[mid])
    node.left = build_bst(low, mid - 1)
    node.right = build_bst(mid + 1, high)
    node
  end
end

#Creating random array of 15 numbers
my_arr = (Array.new(15) { rand(1..100) })

#Constructing a binary search tree from the random array  
my_bst = Tree.new(my_arr)
root_node = my_bst.buildtree

#Below code gives a visual representation of the tree on the console  
my_bst.pretty_print(root_node)

#The below function returns true if the tree is balanced or else it returns false  
p my_bst.is_balanced?(root_node)


#Adding new nodes to the tree  
my_bst.insert(root_node,155)
my_bst.insert(root_node,125)
my_bst.insert(root_node,101)
my_bst.insert(root_node,199)
my_bst.insert(root_node,999)
my_bst.insert(root_node,291)

#After adding new nodes to the tree the BST will become unbalanced and the is_balanced? function should return false as output  
p my_bst.is_balanced?(root_node)

#The 'rebalance' method that we created will create a new tree altogether,we will store this tree in the variable 'rebalanced'  
rebalanced = my_bst.rebalance(root_node)

#Asking again if the new rebalanced tree is a balanced binar search tree  
p my_bst.is_balanced?(rebalanced)  
my_bst.pretty_print(rebalanced)


#Printing all elements in the tree in level, pre, post, and in order  
p my_bst.level_order(rebalanced)
p my_bst.inorder(rebalanced)
p my_bst.preorder(rebalanced)
p my_bst.postorder(rebalanced) 

#fin  