module Rw
  class SuccessResponse
    include Interactor

    def call
      result = {response: ErrorCodes.call.error_codes.no_error.error_code,
                error: I18n.t(:'photographers.messages.success_message')
      }
      if context.object_name
        object = {"#{context.object_name}": context.response_object}
        result.merge!(object)
      end
      if context.additional_json
        result.merge!(context.additional_json)
      end
      if context.response
        result.merge!(context.response)
      end
      context.result = result
    end
  end
end
