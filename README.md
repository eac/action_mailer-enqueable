# ActionMailer::Enqueable

Drop in support for using queues with existing delivery methods. Works with mailers that accept ActiveRecord, and simple JSON-compatible objects as arguments.

## Installation

Add this line to your application's Gemfile:

    gem 'action_mailer-enqueable'

## Usage

```ruby
class EnqueableMailer < ActionMailer::Base
  extend ActionMailer::Enqueable

  self.queue = MailRenderingJob

  def welcome(user)
    recipients   'You'
    from         'Me'

    body "Email: Hello, #{user}"
  end

end

class MailRenderingJob

  def self.enqueue(deferred)
    Resque.enqueue(deferred.encoded)
  end
  
  def self.work(params)
    deferred = ActionMailer::Enqueable::Deferred.from_hash(params)
    deferred.mailer.deliver!
  end

end
````
