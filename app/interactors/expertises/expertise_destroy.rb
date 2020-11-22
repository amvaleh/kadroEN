module Expertises
  class ExpertiseDestroy
    include Interactor

    def call
      expertise = Expertise.find_by(id: context.id)
      if expertise.present?
        Rw::Authorize.call(context.photographer, ExpertisePolicy, :expertise_destroy?, expertise)
        context.photographer.create_activity :ph_delete_expertise, owner: context.photographer, recipient: expertise
        expertise.destroy
      else
        context.errors = I18n.t(:'expertises.messages.not_found')
        context.fail!
      end
    end
  end
end
