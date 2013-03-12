# To change this template, choose Tools | Templates
# and open the template in the editor.



class Dowgrade < Struct.new(:u_id, :pkg,:new_package_no_of_tours,:previous_package_no_of_tours)
  def perform
    user=User.find(u_id)
    user.downgrade_package(pkg,new_package_no_of_tours,previous_package_no_of_tours)
  end
end