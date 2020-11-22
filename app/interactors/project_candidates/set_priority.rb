module ProjectCandidates
  class SetPriority
    include Interactor

    def call
      project = context.project
      if project.search_for_studio
        if context.direct.present? and context.direct
          photographers = Photographer.joins(:project_candidates).where(project_candidates: { project_id: context.project.id, project_candidate_status_id: ProjectCandidateStatus.find_by_title("non_directed").id })
        else
          photographers = Photographer.joins(:project_candidates).where(project_candidates: { project_id: context.project.id, project_candidate_status_id: ProjectCandidateStatus.find_by_title("elected").id })
        end
        phs = photographers.map { |r| r.attributes.symbolize_keys }
        phs.each do |ph|
          if Photographer.find(ph[:id]).projects.confirmed.count > 0
            ph[:experience] = ((ph[:arate] + ph[:qrate]) / 4) + Photographer.find(ph[:id]).projects.confirmed.count
          else
            ph[:experience] = 1
          end
          ph[:rate] = ((ph[:arate] + ph[:qrate]) / 4)
          ph[:transportation_cost] = ProjectCandidate.find_by(project_id: context.project.id, photographer_id: ph[:id].to_i).price.to_i
          ph[:price] = ph[:transportation_cost].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
          photographer = Photographer.find(ph[:id].to_i)
          if photographer.photographer_attachments.any?
            attachments = photographer.photographer_attachments
          end
          ph[:attachments] = attachments
          ph[:avatar] = photographer.avatar

          # FeedBack.joins(:project).where('photographer_id = ? and arate > ? and qrate > ? and description IS NOT ?', photographer.id,8,8,nil).count

          feedbacks = FeedBack.joins(:project).where("photographer_id = ?", photographer.id)
          count = 0
          feedbacks.each do |fb|
            if fb.qrate > 8 and fb.arate > 8 and not fb.description == ""
              count = count + 1
            end
          end
          ph[:comments_count] = count

          # first 4 photos of photographer
          photos = []
          Expertise.approved.find_by(:shoot_type => project.shoot_type, :photographer => photographer).photos.first(4).each do |p|
            photos << p
          end
          ph[:photos] = photos
          shoot_location = ShootLocation.find_by(:is_studio => true, :photographer => photographer)
          studio_photos = []
          length = ((shoot_location.address.detail.length / 4) * 3).to_i
          ph[:stduio_address_detail] = shoot_location.address.detail[0...length] + " ..."
          shoot_location.shoot_location_attachments.first(4).each do |p|
            studio_photos << p
          end
          ph[:studio_photos] = studio_photos
          #

          ph[:distance_to_you] = ProjectCandidate.where(:photographer_id => photographer.id, :project_id => context.project.id).first.distance.round
          ph.except!(:encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :last_sign_in_at, :email, :static_number, :ideal_hours, :join_step_id, :slug, :location_id, :online_portfolio, :instagram, :linkedin, :approved, :rejected, :bank_account_id, :qrate, :arate, :parent_photographer_id, :business_id, :twitter, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :birthday, :checked, :call_status_id, :interview_date, :promissory, :contract, :first_call, :first_call_at)
        end
        rate_sort = phs.sort_by { |ph| -ph[:experience] }.reverse
        price_sort = rate_sort.sort_by { |ph| -ph[:distance_to_you] }.reverse
        count = 1
        price_sort.each do |ph|
          photographer = Photographer.find(ph[:id].to_i)
          project_candidate = ProjectCandidate.find_by(project_id: context.project.id, photographer_id: photographer.id)
          project_candidate.priority = count
          project_candidate.save
          count += 1
        end
        context.photographers = photographers.first(12)
        context.final_photographers = price_sort.first(12)

        # project_candidates = ProjectCandidate.all.where(project_id: context.project.id, project_candidate_status_id: ProjectCandidateStatus.find_by_title("elected").id)
        # distance_sort = project_candidates.sort_by { |pc| [-pc.distance] }.reverse
        # count = 1
        # photographers_ids = []
        # distance_sort.each do |pc|
        #   pc.priority = count
        #   pc.save
        #   photographers_ids << pc.photographer_id
        #   count += 1
        # end
        # photographers = Photographer.all.where(id: photographers_ids)
        # context.photographers = photographers.first(12)
        # context.final_photographers = photographers.first(12)
      else
        if context.direct.present? and context.direct
          photographers = Photographer.joins(:project_candidates).where(project_candidates: { project_id: context.project.id, project_candidate_status_id: ProjectCandidateStatus.find_by_title("non_directed").id })
        else
          photographers = Photographer.joins(:project_candidates).where(project_candidates: { project_id: context.project.id, project_candidate_status_id: ProjectCandidateStatus.find_by_title("elected").id })
        end
        phs = photographers.map { |r| r.attributes.symbolize_keys }
        phs.each do |ph|
          if Photographer.find(ph[:id]).projects.confirmed.count > 0
            ph[:experience] = ((ph[:arate] + ph[:qrate]) / 4) + Photographer.find(ph[:id]).projects.confirmed.count
          else
            ph[:experience] = 1
          end
          ph[:rate] = ((ph[:arate] + ph[:qrate]) / 4)
          ph[:transportation_cost] = ProjectCandidate.find_by(project_id: context.project.id, photographer_id: ph[:id].to_i).price.to_i
          ph[:price] = ph[:transportation_cost].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
          photographer = Photographer.find(ph[:id].to_i)
          if photographer.photographer_attachments.any?
            attachments = photographer.photographer_attachments
          end
          ph[:attachments] = attachments
          ph[:avatar] = photographer.avatar

          # FeedBack.joins(:project).where('photographer_id = ? and arate > ? and qrate > ? and description IS NOT ?', photographer.id,8,8,nil).count

          feedbacks = FeedBack.joins(:project).where("photographer_id = ?", photographer.id)
          count = 0
          feedbacks.each do |fb|
            if fb.qrate > 8 and fb.arate > 8 and not fb.description == ""
              count = count + 1
            end
          end
          ph[:comments_count] = count

          # first 4 photos of photographer
          photos = []
          Expertise.approved.find_by(:shoot_type => project.shoot_type, :photographer => photographer).photos.first(4).each do |p|
            photos << p
          end
          ph[:photos] = photos
          #

          ph[:distance_to_you] = ProjectCandidate.where(:photographer_id => photographer.id, :project_id => context.project.id).first.distance.round
          ph.except!(:encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :last_sign_in_at, :email, :static_number, :ideal_hours, :join_step_id, :slug, :location_id, :online_portfolio, :instagram, :linkedin, :approved, :rejected, :bank_account_id, :qrate, :arate, :parent_photographer_id, :business_id, :twitter, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :birthday, :checked, :call_status_id, :interview_date, :promissory, :contract, :first_call, :first_call_at)
        end
        rate_sort = phs.sort_by { |ph| -ph[:experience] }.reverse
        price_sort = rate_sort.sort_by { |ph| -ph[:transportation_cost] }.reverse
        count = 1
        price_sort.each do |ph|
          photographer = Photographer.find(ph[:id].to_i)
          project_candidate = ProjectCandidate.find_by(project_id: context.project.id, photographer_id: photographer.id)
          project_candidate.priority = count
          project_candidate.save
          count += 1
        end
        context.photographers = photographers.first(12)
        context.final_photographers = price_sort.first(12)
      end
    end
  end
end
