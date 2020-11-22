module EmailTracker
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      req = ::Rack::Request.new(env)

      if req.path_info =~ /^\/email\/track\/(.+).png/
        details = Base64.strict_decode64(Regexp.last_match[1])
        name = nil
        email = nil
        id = nil
        type = nil

        details.split('&').each do |kv|
          (key, value) = kv.split('=')
          case(key)
          when('name')
            name = value
          when('email')
            email = value
          when('id')
            id = value
          when ('type')
            type = value
          end
        end
        case(type)
        when('photographer')
          if name && email
            SentPhotographerEmailOpen.create!({
              :sent_photographer_email_id => id,
              :name => name,
              :email => email,
              :ip_address => req.ip,
              :opened => DateTime.now
              })
            end

            seen = SentPhotographerEmail.find(id)
            seen.number_of_seen = seen.number_of_seen + 1
            seen.opened = true
            seen.save
          when('user')
            if name && email
              SentUserEmailOpen.create!({
                :sent_user_email_id => id,
                :name => name,
                :email => email,
                :ip_address => req.ip,
                :opened => DateTime.now
                })
              end

              seen = SentUserEmail.find(id)
              seen.number_of_seen = seen.number_of_seen + 1
              seen.opened = true
              seen.save
            when('project')
              if name && email
                SentProjectEmailOpen.create!({
                  :sent_project_email_id => id,
                  :name => name,
                  :email => email,
                  :ip_address => req.ip,
                  :opened => DateTime.now
                  })
                end

                seen = SentProjectEmail.find(id)
                seen.number_of_seen = seen.number_of_seen + 1
                seen.opened = true
                seen.save
              end
              [ 200, { 'Content-Type' => 'image/png' }, [ File.read(File.join(File.dirname(__FILE__), 'track.png')) ] ]
            else
              @app.call(env)
            end
          end
        end
      end
