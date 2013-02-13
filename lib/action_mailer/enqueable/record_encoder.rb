require 'active_support'

# Prepare ActiveRecord objects for safe serialization.
#
# user = User.first
# => #<User id: 1, account_id: 1, name: 'Buddhy'>
# RecordEncoder.encode(user)
# => { :class => 'User', :id => 1 }
# RecordEncoder.decode(user)
# => #<User id: 1, account_id: 1, name: 'Buddhy'>
#
module ActionMailer::Enqueable::RecordEncoder
  class RecordIdMissingError < ArgumentError
    def initialize(record)
      @record = record
    end

    def message
      "ActiveRecords must have an id to be serialized: (#{@record.inspect})"
    end
  end
  CLASS = 'class'.freeze
  ID    = 'id'.freeze

  extend self

  def encode(params)
    encoded = params.map do |argument|
      case argument
      when ActiveRecord::Base
        encode_active_record(argument)
      when Array, Hash
        encode(argument)
      when NilClass, TrueClass, FalseClass, Numeric, String, Symbol
        argument
      else
        raise ArgumentError.new("Cannot encode #{argument} (#{argument.class})")
      end
    end

    params.is_a?(Hash) ? Hash[encoded] : encoded
  end

  def decode(params)
    decoded = params.map do |argument|
      case argument
      when Hash
        active_record?(argument) ? decode_active_record(argument) : decode(argument)
      when Array
        decode(argument)
      else
        argument
      end
    end

    params.is_a?(Hash) ? Hash[decoded] : decoded
  end

  protected

  def decode_active_record(params)
    params[CLASS].constantize.find(params[ID])
  end

  def active_record?(params)
    params[CLASS] && params[ID]
  end

  def encode_active_record(record)
    raise RecordIdMissingError.new(record) if record.id.to_s.empty?

    { CLASS => record.class.name, ID => record.id }
  end

end

