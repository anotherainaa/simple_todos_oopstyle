class Todo
  attr_accessor :id, :title, :done

  def initialize(id, title, done = false)
    @id = id
    @title = title
    @done = done
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      done == otherTodo.done
  end
end
