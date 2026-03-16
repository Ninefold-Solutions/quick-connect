class ToggleTask < Patterns::Service
  def initialize(task, actor, contact)
    @task = task
    @actor = actor
    @contact = contact
  end

  def call
    begin
      toggle
    rescue
      task
    end

    task
  end

  private

  def toggle_task
    task.completed = !task.completed
    task.save!
  end

  attr_reader :task, :actor, :contact
end
