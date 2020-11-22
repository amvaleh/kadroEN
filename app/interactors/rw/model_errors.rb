module Rw
  class ModelErrors
    include Interactor

    def call
      complete_errors = []
      error_keys = context.model.errors.keys.map { |e| [e.to_s] }
      context.model.errors.keys.each do |key|
        complete_errors << context.model.errors.messages[key][0]
      end
      context.class_name.instance_variable_set('@complete_errors', complete_errors)
      context.class_name.instance_variable_set('@error_keys', error_keys)
    end
  end
end