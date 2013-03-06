# To change this template, choose Tools | Templates
# and open the template in the editor.

class ToursJobs < Struct.new(:option)
  def perform
     s_pkg=SelectedPackage.find(option)
     
     s_pkg.tours_disable
    
  end
end
