require 'action_mailer/enqueable/version'
require 'action_mailer/enqueable/deferred'
require 'active_support/core_ext/class/attribute'

module ActionMailer::Enqueable
  class Proxy
    attr_reader :mailer_class

    def initialize(mailer_class, method_id, arguments)
      @mailer_class = mailer_class
      @method_id = method_id
      @arguments = arguments
    end

    def deliver
      deferred = Deferred.new(:mailer_name => @mailer_class.name, :method_id => @method_id.to_s, :arguments => @arguments)
      @mailer_class.queue.enqueue(deferred)
      deferred
    end

    def create
      @mailer_class.send(:method_missing_without_proxy, @method_id, *@arguments)
    end
  end

  def self.extended(base)
    base.class_attribute :queue
    class << base
      alias_method :method_missing_without_proxy, :method_missing

      def method_missing(name, *args, &block)
        if queue
          Proxy.new(self, name, args)
        else
          super
        end
      end
    end
  end
end
