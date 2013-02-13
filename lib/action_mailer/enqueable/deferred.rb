require 'action_mailer/enqueable/record_encoder'
require 'active_support/core_ext/hash'

module ActionMailer::Enqueable
  class Deferred
    class Invalid < ArgumentError
    end

    def self.from_json(params)
      from_hash(ActiveSupport::JSON.decode(params))
    end

    def self.from_hash(params)
      decoded = encoder.decode(params)

      new(decoded)
    end

    def self.encoder
      RecordEncoder
    end

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @params.symbolize_keys!
    end

    # ActionMailer does some bizzare stuff with #new.
    def mailer
      @mailer ||= begin
                    mailer = mailer_class.allocate
                    mailer.send(:initialize, method_id, *arguments)
                    mailer
                  end
    end

    def mailer_class
      mailer_name.constantize
    end

    def mailer_name
      params[:mailer_name]
    end

    def method_id
      params[:method_id]
    end

    def arguments
      params[:arguments]
    end

    def attributes
      { :mailer_name => mailer_name, :method_id => method_id, :arguments => arguments }
    end

    def validate!
      valid? || raise(Invalid.new("Deferred mailer is invalid: #{errors.inspect}"))
    end

    def valid?
      @errors = attributes.map do |name, value|
        "#{name} can't be nil" if value.nil?
      end
      @errors.compact!

      @errors.empty?
    end

    def to_json(options = {})
      ActiveSupport::JSON.encode(encoded)
    end

    def encoded
      self.class.encoder.encode(params)
    end

    def ==(other)
      other.respond_to?(:params) &&
        other.params == params
    end

  end
end
