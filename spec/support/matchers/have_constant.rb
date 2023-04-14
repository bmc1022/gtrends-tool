# frozen_string_literal: true

RSpec::Matchers.define(:have_constant) do |const|
  match do |owner|
    if @value.nil?
      owner.const_defined?(const)
    else
      owner.const_defined?(const) && owner.const_get(const) == @value
    end
  end

  chain :with_value do |value|
    @value = value
  end

  failure_message do |actual|
    msg = +"constant #{const} not defined in #{actual}"
    msg += " with value #{@value}" unless @value.nil?
    msg
  end

  failure_message_when_negated do |actual|
    msg = +"constant #{const} is defined in #{actual}"
    msg += " with value #{@value}" unless @value.nil?
    msg
  end

  description do
    msg = +"have constant #{const}"
    msg += " and value #{@value}" unless @value.nil?
    msg
  end
end

RSpec::Matchers.alias_matcher(:define_constant, :have_constant)
