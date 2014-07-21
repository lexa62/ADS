module Admin
  class BaseController < ApplicationController
    before_filter :verify_admin

    private

    def verify_admin
      if current_user.nil? or !current_user.admin?
        raise CanCan::AccessDenied
      end
    end
  end
end
