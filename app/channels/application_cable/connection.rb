module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verfied_user
    end

    def session
      cookies.encrypted[Rails.application.config.session_options[:key]]
    end

    protected
    def find_verfied_user
      #if current_user = User.find_by(id: session["user_id"])
        #current_user
      if session
        if not session["user_id"].nil?
          session["user_id"]
        else
          reject_unauthorized_connection
        end
      else
        reject_unauthorized_connection
      end
    end

  end
end
