module UsersHelper

  def user_next_join_step(user,business,request)

    business_projects_path(business,request)
    # if user.first_name.present? && user.last_name.present? && user.email.present?
    #   package_projects_path
    # else
    #   package_projects_path
    # end
  end


end
