class AddMlsidToTours < ActiveRecord::Migration
  def change
    begin
    add_column :tours, :mls_id, :string
    add_column :tours, :store_realtor, :boolean, :default => false
    rescue
    end
    #Tour.all.each{|tour|
     # tour.store_realtor=false
      #tour.save
    #}
  
  end
end
