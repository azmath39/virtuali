class AddPhnoToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :phno, :string
  end
end
