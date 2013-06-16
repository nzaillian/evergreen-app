module ActiveRecord
  class Base
    def warnings
      if !@warnings
        @warnings = ActiveModel::Warnings.new(self)
      end
      @warnings
    end
    
    def no_warnings?
      warnings.empty?
    end

    def warnings?
      warnings.size > 0
    end
    
    def complete?
      valid? and no_warnings?
    end
  end
end

class OnlyWarnValidator < ActiveModel::EachValidator
  def validate(record)
    record.warnings.add_on_blank(attributes, options)
  end
end