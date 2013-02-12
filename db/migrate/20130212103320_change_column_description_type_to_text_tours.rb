class ChangeColumnDescriptionTypeToTextTours < ActiveRecord::Migration
  def change
    change_column :tours, :description, :text, :limit => nil
  end
 end
