class ApplicationMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  add_template_helper(ApplicationHelper)
  default from: 'support@kadro.co'
  layout 'mailer'
end
