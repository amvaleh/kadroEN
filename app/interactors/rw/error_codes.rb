module Rw
  class ErrorCodes
    include Interactor

    NO_ERROR = 0
    EXCEPTION_ERROR = 999
    AUTHENTICATE_ERROR = 101
    VALIDATE_ERROR = 103
    PERMISSION_ERROR = 105

    ErrorCode = Struct.new(:authenticate_error,
      :validate_error,
      :no_error,
      :exception_error,
      :permission_error
    )

    Error = Struct.new(:error_code, :message)

    def call
      no_error = error_pair(NO_ERROR, I18n.t(:'messages.no_error'))
      authenticate_error = error_pair(AUTHENTICATE_ERROR, I18n.t(:'messages.authenticate_error'))
      validate_error = error_pair(VALIDATE_ERROR, I18n.t(:'messages.validate_error'))
      exception_error = error_pair(EXCEPTION_ERROR, I18n.t(:'messages.exception_error'))
      permission_error = error_pair(PERMISSION_ERROR, I18n.t(:'messages.permission_error'))

      error_codes = ErrorCode.new

      error_codes.no_error = no_error
      error_codes.authenticate_error = authenticate_error
      error_codes.validate_error = validate_error
      error_codes.exception_error = exception_error
      error_codes.permission_error = permission_error

      context.error_codes = error_codes
    end

    def error_pair(error_code, message)
      error = Error.new
      error.error_code = error_code
      error.message = message
      error
    end
  end
end
