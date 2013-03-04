class AddPicturesForTourSelPkgAndPaymentPeriodUser < ActiveRecord::Migration
  def change
    add_column :selected_packages, :pictures_for_tour, :integer
    add_column :selected_packages, :payment_period_type, :integer
    add_column :selected_packages, :renew_date, :date
  end
end
