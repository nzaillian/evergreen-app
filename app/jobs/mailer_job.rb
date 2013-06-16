# A simple class to invoke "deliver" on the supplied
# mailer class and method with the supplied arguments
# (consumed by the Delayed::Job queue)
class MailerJob < Object
  def initialize(klass, method, *arguments)
    @klass, @method, @arguments = klass, method, arguments
  end

  def perform
    @klass.send(@method, *@arguments).deliver
  end
end