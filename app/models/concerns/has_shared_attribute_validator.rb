# example:
# class SupervisorVolunteer < ApplicationRecord
#   belongs_to :volunteer, class_name: "User"
#   belongs_to :supervisor, class_name: "User"
#   validates :supervisor, has_shared_attribute: {shared_attribute: :casa_org, shared_with: :volunteer}
# end

class HasSharedAttributeValidator < ActiveModel::EachValidator
  def validate_each(*args)
    Validator.new(*args, options).validate
  end

  class Validator
    attr_reader :object_attribute, :object, :options, :record

    def initialize(record, object_attribute, object, options = {})
      @record = record
      @object_attribute = object_attribute
      @object = object
      @options = options
    end

    def validate
      return if missing_objects? || objects_share_attribute?

      record.errors.add object_attribute, error_message
    end

    private

    def missing_objects?
      objects.any?(&:blank?)
    end

    def objects
      [object, other_object]
    end

    def other_object
      return if other_object_attribute.blank?

      @other_object ||= record.send other_object_attribute
    end

    def other_object_attribute
      @other_object_attribute ||= options[:shared_with]
    end

    def objects_share_attribute?
      object.send(shared_attribute) == other_object.send(shared_attribute)
    end

    def shared_attribute
      @shared_attribute ||= options[:shared_attribute]
    end

    def error_message
      custom_error_message || default_error_message
    end

    def custom_error_message
      options[:message]
    end

    def default_error_message
      "and #{other_object_attribute.to_s.humanize} must have the same #{shared_attribute.to_s.humanize}"
    end
  end
end
