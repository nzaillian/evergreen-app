module Evergreen
  module Exceptions
    class CompanyNotCreatedException < Exception
      def initialize(msg=nil)
        super(msg)
      end
    end
  end
end
