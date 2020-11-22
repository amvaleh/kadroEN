module ProjectCandidates
  class ProjectCandidateCreate
    include Interactor

    def call
      elected_status = ProjectCandidateStatus.find_by_title("elected").id
      non_directed = ProjectCandidateStatus.find_by_title("non_directed").id
      extra_transportation = Setting.find_by_var("extra_transportation").value.to_i
      rational_distance = context.project.package.rational_distance
      free_times = []
      delete_item = []
      price = 0
      context.data.free_times.each do |free_time|
        free_times << free_time
      end
      context.data.photographers.each do |photographer|
        distance = photographer.location.distance_to([context.project.address.lattitude.to_f, context.project.address.longtitude.to_f])
        if context.project.search_for_studio
          price = 0
        else
          if (distance - rational_distance) > 0
            # distance_to_pay = distance - rational_distance
            case distance
            when 0..5
              price = (distance * 6500).round
            when 5..10
              price = (distance * 4300).round
            when 10..15
              price = (distance * 3500).round
            when 15..20
              price = (distance * 3100).round
            when 20..25
              price = (distance * 2800).round
            when 25..30
              price = (distance * 2800).round
            when 30..35
              price = (distance * 2800).round
            when 35..40
              price = (distance * 2800).round
            else
              price = (distance * 3000).round
            end
            if price < 6500
              price = 6500
            else
              price = (price / 100).to_i
              price = price * 100
            end
            if context.project.in_studio
              price = 0
            end
          else
            price = 0
          end
        end
        if price > ((context.project.package.price.to_f * 3) / 4) or (context.project.search_for_studio == true and distance > 30)
          context.data.free_times.each do |free_time|
            if free_time.photographer_id == photographer.id
              delete_item << free_time
            end
          end
        else
          if ProjectCandidate.where(project_id: context.project.id, photographer_id: photographer.id).any?
            # do nothing here. dont create multiple project candidates for a single ph!
          else
            if context.photographer_uid.present?
              if photographer.uid == context.photographer_uid # direct book
                project_candidate = ProjectCandidate.new(project_id: context.project.id, photographer_id: photographer.id, project_candidate_status_id: elected_status, distance: distance, price: price)
                project_candidate.save
              else
                project_candidate = ProjectCandidate.new(project_id: context.project.id, photographer_id: photographer.id, project_candidate_status_id: non_directed, distance: distance, price: price)
                project_candidate.save
              end
            else # normal candidate
              project_candidate = ProjectCandidate.new(project_id: context.project.id, photographer_id: photographer.id, project_candidate_status_id: elected_status, distance: distance, price: price)
              project_candidate.save
            end
          end
        end
      end
      context.free_times = free_times - delete_item
    end
  end
end
