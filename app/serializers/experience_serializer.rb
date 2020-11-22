class ExperienceSerializer < ActiveModel::Serializer
  attributes :id, :years_been_photographer, :has_payed_work, :projects_payed_count, :self_describe, :bio,
             :passion, :love_job, :favorite_shoots, :shoots, :city_shoots, :awards, :fun_fact
end