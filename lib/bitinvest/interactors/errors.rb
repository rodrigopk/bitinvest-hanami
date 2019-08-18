# frozen_string_literal: true

class InteractorErrors
  class << self
    def user_not_found
      :user_not_found
    end

    def email_already_taken
      :email_already_taken
    end
  end
end
