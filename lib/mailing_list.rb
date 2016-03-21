class MailingList
  def initialize
    @mailchimp = Mailchimp::API.new(required_env('DEV_GARDEN_MAILCHIMP_API_KEY'))
    @list_id = required_env 'DEV_GARDEN_MAILCHIMP_LIST_ID'
  end

  def subscription_status(email)
    result = @mailchimp.lists.member_info @list_id, [{ email: email }]
    result['data']&.first['status']
  end

  def subscribe!(email)
    @mailchimp.lists.subscribe @list_id, { email: email }
  end

private

  def required_env(key)
    value = ENV[key]
    raise "Missing required env var: #{key}" if value.blank?
    value
  end
end
