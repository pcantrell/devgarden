class AddMailingListOfferFlagToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :mailing_list_subscription_offered, :boolean, null: false, default: false
  end
end
