module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |e|
          render json: { errors: [e.message] }, status: 404
        end

        rescue_from Koala::Facebook::APIError do |e|
          render json: { errors: [e.message] }, status: 500
        end

        rescue_from Koala::Facebook::ClientError do |e|
          render json: { errors: [e.message] }, status: 422
        end

        rescue_from Koala::Facebook::ServerError do |e|
          render json: { errors: [e.message] }, status: 503
        end
      end
    end
  end
end