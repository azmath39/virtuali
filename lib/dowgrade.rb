# To change this template, choose Tools | Templates
# and open the template in the editor.



class Dowgrade < Struct.new(:u_id, :s_pkg_id)
  def perform
    user=User.find(u_id)
    user.downgrade_package(s_pkg_id)
  end
end