module ScannedProfiles
  class ScannedProfileUpdate
    include Interactor

    def call
      scanned_profile = context.scanned_profile
      if context.data[:birthـcertificate].present?
        scanned_profile.birthـcertificate = context.data[:birthـcertificate]
      end
      if context.data[:national_card].present?
        scanned_profile.national_card = context.data[:national_card]
      end
      if scanned_profile.save
        context.scanned_profile = scanned_profile
      else
        context.errors = scanned_profile.errors.messages
        context.fail!
      end
    end
  end
end
