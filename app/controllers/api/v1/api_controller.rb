module Api
  module V1
    class ApiController < ActionController::Base
      # skip_before_action :verify_authenticity_token
      before_action :check_basic_auth
      rescue_from ActiveRecord::RecordNotFound, with: :render_404

      def check_basic_auth
        params[:email] params[:password]
        # authenticate_with_http_basic do |email, user_token|
          user = User.authenticate(email, user_token)
          unless user.empty?
            @current_user = user
          else
            head :unauthorized
          end
        end
      end

      def current_user
        @current_user
      end

      def render_404
        render json: { error: 'Task not found', status: 404 }
      end
    end
  end
end