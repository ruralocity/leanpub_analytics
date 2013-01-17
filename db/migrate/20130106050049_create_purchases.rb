class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :leanpub_id
      t.float :total_paid
      t.float :royalty
      t.string :bundle_slug
      t.date :purchased_on
      t.date :paid_on
      t.string :coupon_code
      t.string :coupon_note
      t.string :email

      t.timestamps
    end
  end
end
