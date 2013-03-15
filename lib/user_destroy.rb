# To change this template, choose Tools | Templates
# and open the template in the editor.

class UserDestroy < Struct.new(:option)
  def perform
     user=User.find(option)
     user.selected_package.destroy unless user.selected_package.nil?
     user.destroy
  end
end