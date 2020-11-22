module Refers
  class ReferCreate
    include Interactor

    def call
      refer_form = ReferForm.new(Refer.new)

      if refer_form.validate(context.data)
        refer_form.save
        context.refer = refer_form
      else
        context.refer = refer_form
        context.fail!
      end
    end
  end
end