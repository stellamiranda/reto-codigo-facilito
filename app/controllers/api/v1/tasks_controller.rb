module Api
  module V1
    class TasksController < ApiController

      before_action :set_task, only: [:show, :destroy, :image]

      #GET api/v1/tasks
      def index
        @tasks = current_user.tasks
        render json: @tasks
      end
      
      #GET api/v1/tasks/:id
      def show
        # @task = Task.find(params[:id]) 
        # ^ defined in before_action :set_task
        render json: @task
      end
      
      # POST /api/v1/tasks
      # params title and description
      def create
        @task = Task.new(task_params)
        # TODO: Implement auth 
        # @task.user_id = current_user.id
        @task.user_id = User.first.id
        if @task.save
          render json: @task, status: 200
        else
          message_error = "Task could not be saved."
          @task.errors.full_messages.each do |error|
            message_error = message_error + " & " + error
          end
          # render error: { error: message_error, status: 400 }
          render error: { error: 'Unable to save this task', status: 400 }
        end

      end
    
      # DELETE /api/v1/tasks/:id
      def destroy
        # @task = Task.find(params[:id]) 
        @task.destroy
        # render message: { error: 'Unable to save this task', status: 400 }
        head :no_content
      end

      def image
        if @task.image.attached? 
          render json: @task.image
        else
          render error: { error: 'Unable to display image for this task', status: 400 }
        end
      end 
      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :image)
      end
    end
  end
end