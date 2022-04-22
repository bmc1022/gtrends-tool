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
      @instance.update!("#{@association}_attributes": { })
      @instance.update!("#{@association}_attributes": empty_attributes)
      @instance.send(@association).blank?
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
      @instance.class.name.constantize.reflect_on_all_associations.detect{|assoc| assoc.name == @association}
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
      attrs = associated_class.columns.select { |col| col.sql_type =~ /character/ }.map { |col| [col.name, '' ] }.to_h
      case associated_type
        when "HasOneReflection"  then attrs
        when "HasManyReflection" then [attrs]
      end
    end
  end
end

RSpec.configure do |config|
  config.include RejectBlankNestedAttributesForMatcher
end
