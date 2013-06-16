module ActiveRecord
  class Base
    # Specifies that values of the given attributes should be returned
    # as symbols. The table column should be created of type string.
    def self.symbolize (*attr_names)
      attr_names.each do |attr_name|
        attr_name = attr_name.to_s
        class_eval("def #{attr_name}; read_and_symbolize_attribute('#{attr_name}'); end")
        class_eval("def #{attr_name}= (value); write_attribute('#{attr_name}', value.to_s); end")
      end
    end
    # Return an attribute's value as a symbol
    def read_and_symbolize_attribute (attr_name)
      value = read_attribute(attr_name)
      value.blank? ? nil : value.to_sym
    end
  end
end