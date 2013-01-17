require 'csv'

class Purchase < ActiveRecord::Base
  attr_accessible :bundle_slug, :coupon_code, :coupon_note, :email,
    :leanpub_id, :paid_on, :purchased_on, :royalty, :total_paid

  MAPPINGS = {
    "Bundle slug" => "bundle_slug",
    "Purchase ID" => "leanpub_id",
    "Total Paid" => "total_paid",
    "Your Royalty" => "royalty",
    "Purchased at" => "purchased_on",
    "Paid out at" => "paid_on",
    "Coupon code" => "coupon_code",
    "Coupon_note" => "coupon_note",
    "Email" => "email"
  }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      purchase = find_by_leanpub_id(row["Purchase ID"]) || new
      purchase.attributes = Hash[row.to_hash.map {|k,v|[MAPPINGS[k], v]}].slice(*accessible_attributes)
      # raise purchase.attributes.inspect
      purchase.save!
    end
  end
end
