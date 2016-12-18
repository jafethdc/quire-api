module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |e|
          render json: { errors: [e.message] }, status: 404
        end

        rescue_from Exceptions::UnauthorizedError do |e|
          render json: { errors: [e.message] }, status: 401
        end
      end
    end
  end
end