require 'yaml'

require_relative 'list'
require_relative 'todo'

class ListRepo
  attr_accessor :lists

  def initialize
    @lists = []
    load_lists
  end

  def all
    @lists
  end

  def load_lists
    lists = Psych.load_file("./todos.yml")

    lists.each do |list|
      new_list = List.new(
        list[:id],
        list[:title],
        list[:todos].map do |todo|
          Todo.new(todo[:id], todo[:title], todo[:done])
        end
        )
      @lists << new_list
    end
  end

  def save_lists
    lists = []

    @lists.each do |list|
      formatted_list = {}

      formatted_list[:id] = list.id
      formatted_list[:title] = list.title

      formatted_list[:todos] = []

      list.todos.each do |todo|
        formatted_todo = {}

        formatted_todo[:id] = todo.id
        formatted_todo[:title] = todo.title
        formatted_todo[:done] = todo.done

        formatted_list[:todos] << formatted_todo
      end

      lists << formatted_list
    end

    File.open('./todos.yml', 'w') do |file|
      file.write(Psych.dump(lists))
    end
  end

  def item_at(id)
    @lists.find do |list|
      list.id == id
    end
  end

  def <<(list)
    raise TypeError, 'can only add List objects' unless list.instance_of? List

    @lists << list
  end
  alias_method :add, :<<

  def unique_title?(list_title)
    @lists.all? { |list| list.title != list_title }
  end

  def remove_at(id)
    @lists.delete(item_at(id))
  end
end
