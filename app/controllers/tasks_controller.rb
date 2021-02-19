class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :destroy]
  
  def index
    # option 1
    # @tasks = Task.where(user_id: current_user.id)
    # option 2
    @tasks = current_user.tasks
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to tasks_path, notice: "Task saved!"
    else
      message_error = "Task could not be saved. " 
      @task.errors.full_messages.each do |error|
        message_error = message_error + " & " + error
      end
      flash.alert = message_error
      render :new
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task destroyed!"
  end

  private 

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :image)
  end
end
