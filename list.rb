require_relative 'todo'
require 'yaml'

# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class List
  attr_accessor :title, :todos, :id

  def initialize(id, title, todos = [])
    @id = id
    @title = title
    @todos = todos
  end

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def done?
    @todos.all? { |todo| todo.done? }
  end

  def <<(todo)
    raise TypeError, 'can only add Todo objects' unless todo.instance_of? Todo

    @todos << todo
  end
  alias_method :add, :<<

  def item_at(id)
    @todos.find do |todo|
      todo.id == id
    end
  end

  def remove_at(id)
    @todos.delete(item_at(id))
  end

  def mark_done_at(id)
    item_at(id).done!
  end

  def mark_undone_at(id)
    item_at(id).undone!
  end

  def done!
    @todos.each do |todo|
      mark_done_at(todo.id)
    end
  end

  def each
    @todos.each do |todo|
      yield(todo)
    end
    self
  end

  def mark_all_undone
    each { |todo| todo.undone! }
  end
end

#   def to_a
#     @todos.clone
#   end

#   def select
#     list = TodoList.new(title)
#     each do |todo|
#       list.add(todo) if yield(todo)
#     end
#     list
#   end

#   # returns first Todo by title, or nil if no match
#   def find_by_title(title)
#     select { |todo| todo.title == title }.first
#   end

#   def all_done
#     select { |todo| todo.done? }
#   end

#   def all_not_done
#     select { |todo| !todo.done? }
#   end

#   def mark_done(title)
#     find_by_title(title) && find_by_title(title).done!
#   end

#   def mark_all_done
#     each { |todo| todo.done! }
#   end

#   def mark_all_undone
#     each { |todo| todo.undone! }
#   end
# end
