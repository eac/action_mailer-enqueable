require_relative 'helper'
require 'action_mailer'
require 'action_mailer/enqueable'

class EnqueableTest < Minitest::Test

  class EnqueableMailer < ActionMailer::Base
    extend ActionMailer::Enqueable

    self.delivery_method = :test

    def welcome(user)
      mail(
        :to => 'You',
        :from => 'Me',
        :body => "Email: Hello, #{user}"
      )
    end

  end

  class Queue < Array
    alias enqueue push
  end

  describe 'Mailer with a queue' do
    before do
      @queue = Queue.new
      EnqueableMailer.queue = @queue
    end

    it 'enqueues messages instead of deliverying them' do
      deferred = EnqueableMailer.welcome('Buddhy').deliver

      assert_equal EnqueableMailer, deferred.mailer_class
      assert_equal 'welcome',       deferred.method_id
      assert_equal [ 'Buddhy' ],    deferred.arguments

      deferred = ActionMailer::Enqueable::Deferred.new(:mailer_name => 'EnqueableTest::EnqueableMailer', :method_id => 'welcome', :arguments => [ 'Buddhy' ] )
      assert_equal [ deferred ], @queue
    end

    it 'returns a proxy that turns into a mail on create' do
      mail = EnqueableMailer.welcome('Buddhy').create
      assert_equal ["You"], mail.to
    end

  end

  describe 'Mailer without a queue' do
    before do
      EnqueableMailer.queue = nil
    end

    it 'delivers messages without attempting to enqueue' do
      mail = EnqueableMailer.welcome('Buddhy').deliver
      assert_equal 'Email: Hello, Buddhy', mail.body.to_s
    end

  end

end
