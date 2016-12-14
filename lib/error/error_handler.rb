module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |_|
          render json: { errors: [ {  title: 'resource not found',
                                      description: 'resource not found'} ] }
        end
      end
    end
  end
end