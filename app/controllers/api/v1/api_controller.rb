module Api
  module V1
    class ApiController < ActionController::Base
      # skip_before_action :verify_authenticity_token
      before_action :check_basic_auth
      rescue_from ActiveRecord::RecordNotFound, with: :render_404

      def check_basic_auth
        email, user_token = request.headers["email"], request.headers["token"]
        # authenticate_with_http_basic do |email, user_token|
        if user = User.authenticate(email, user_token)
          @current_user = user
        else
          head :unauthorized
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
