require 'mailing_list'

class SubscribeToMailingListJob < ApplicationJob
  queue_as :default

  def perform(person)
    Person.transaction do
      if !person.email?
        logger.info "Not offering subscription: no email for #{person}"

      elsif person.mailing_list_subscription_offered
        logger.info "Mailing list subscription already offered to #{person.email}"

      else
        mailing_list = MailingList.new
        status = mailing_list.subscription_status(person.email)
        if status
          logger.info "MailChimp has already subscribed #{person.email} (status=#{status.inspect}); updating DB"
        else
          logger.info "Offering mailing list subscription to #{person.email}"

          mailing_list.subscribe!(person.email)
        end

        person.mailing_list_subscription_offered = true
        person.save!
      end
    end
  end
end
