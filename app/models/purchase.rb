require 'csv'

class Purchase < ActiveRecord::Base
  attr_accessible :bundle_slug, :coupon_code, :coupon_note, :email,
    :leanpub_id, :paid_on, :purchased_on, :royalty, :total_paid

  MAPPINGS = {
    "Bundle slug" => "bundle_slug",
    "Purchase ID" => "leanpub_id",
    "Total Paid for Book" => "total_paid",
    "Total Book Royalty" => "royalty",
    "Date Purchased" => "purchased_on",
    "Date Author Royalty Was Paid" => "paid_on",
    "Coupon Code" => "coupon_code",
    "Coupon Note" => "coupon_note",
    "Email If Shared" => "email"
  }

  def self.most_recent
    Purchase.last.try(:created_at)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      purchase = find_by_leanpub_id(row["Purchase ID"]) || new
      row["Total Paid for Book"] = dollars_to_f(row["Total Paid for Book"])
      row["Total Book Royalty"] = dollars_to_f(row["Total Book Royalty"])
      purchase.attributes = Hash[row.to_hash.map {|k,v|[MAPPINGS[k], v]}].slice(*accessible_attributes)
      # raise purchase.attributes.inspect
      purchase.save!
    end
  end

  private

  def self.dollars_to_f(amount)
    amount.delete('$,').to_f
  end
end
