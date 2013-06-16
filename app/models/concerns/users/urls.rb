module Users
  module Urls
    extend ActiveSupport::Concern

    included do
      def home_path
        if companies.length == 1
          urls.company_questions_path(companies.first)
        elsif company_owner && ! owned_company
          urls.new_admin_company_path
        elsif  companies.length > 1
          urls.admin_companies_path
        else
          urls.root_path
        end
      end      
    end
  end
end