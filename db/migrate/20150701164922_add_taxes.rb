class AddTaxes < ActiveRecord::Migration
  def change
    Tax.create(province: 'Alberta', gst: 5, pst: 0)
    Tax.create(province: 'British Columbia', gst: 5, pst: 7)
    Tax.create(province: 'Manitoba', gst: 5, pst: 8)
    Tax.create(province: 'New Brunswick', gst: 13, pst: 0)
    Tax.create(province: 'Newfoundland and Labrador', gst: 13, pst: 0)
    Tax.create(province: 'Northwest Territories', gst: 5, pst: 0)
    Tax.create(province: 'Nova Scotia', gst: 15, pst: 0)
    Tax.create(province: 'Nunavut', gst: 5, pst: 0)
    Tax.create(province: 'Ontario', gst: 13, pst: 0)
    Tax.create(province: 'Quebec', gst: 5, pst: 9.975)
    Tax.create(province: 'Prince Edward Island', gst: 14, pst: 0)
    Tax.create(province: 'Saskatchewan', gst: 5, pst: 5)
    Tax.create(province: 'Yukon', gst: 5, pst: 0)
  end
end
