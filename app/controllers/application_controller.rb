class ApplicationController < ActionController::Base
    before_action :require_login
    helper_method :logged_in

    private
    
    def current_user
        User.find_by(email: session[:email])
    end

    def logged_in
        !current_user.nil?
    end

    def current_user_has_edit_access_to_narrative(narrative)
        current_user.id == narrative.user.id
    end

    def current_user_has_edit_access_to_document(document)
        current_user_has_edit_access_to_narrative(document.narrative)
        #current_user.id == document.narrative.user.id
    end

    def require_login
        unless logged_in
            flash[:error] = "You must be logged in to access this feature."
            redirect_to "/signin"
        end
    end

    #def form_submit_message_prefix(is_new)
    #    is_new ? "Create" : "Update"
    #end
end
