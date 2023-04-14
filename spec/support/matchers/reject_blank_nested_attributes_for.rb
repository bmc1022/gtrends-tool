# frozen_string_literal: true

module RejectBlankNestedAttributesForMatcher
  def reject_blank_nested_attributes_for(association)
    RejectBlankNestedAttributesForMatcher.new(association)
  end

  class RejectBlankNestedAttributesForMatcher
    def initialize(association)
      @association = association
    end

    def matches?(instance)
      @instance = instance
      @instance.update!("#{@association}_attributes": {})
      @instance.update!("#{@association}_attributes": empty_attributes)
      @instance.public_send(@association).blank?
    end

    def description
      "reject :#{@association} if all attributes are blank"
    end

    def failure_message
      "an empty :#{@association} was persisted where it should have been rejected"
    end

    private

    def find_association
      # Use the parent class to find the nested association.
      @instance.class.name.constantize.reflect_on_all_associations.find do |assoc|
        assoc.name == @association
      end
    end

    def associated_class
      # Return the class of the association that's been passed in.
      find_association.class_name.constantize
    end

    def associated_type
      find_association.class.to_s.demodulize
    end

    def empty_attributes
      # Create a hash that contains empty strings for every column on the class with a string type.
      string_cols = associated_class.columns.select { |col| col.sql_type.include?("character") }
      attrs = string_cols.to_h { |col| [col.name, ""] }

      case associated_type
      when "HasOneReflection"  then attrs
      when "HasManyReflection" then [attrs]
      end
    end
  end
end

RSpec.configure { |config| config.include(RejectBlankNestedAttributesForMatcher) }
