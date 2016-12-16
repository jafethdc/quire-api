module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |e|
          #byebug
          render json: { errors: ["No #{e.model} with id #{e.id} was found"] }, status: 404
        end
      end
    end
  end
end