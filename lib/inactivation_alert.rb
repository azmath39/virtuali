# To change this template, choose Tools | Templates
# and open the template in the editor.

class InactivationAlert < Struct.new(:u_id)
  def perform
    user=User.find(u_id)
    user.destroy_delay_job
    s_pkg=user.selected_package
    d=Delayed::Job.enqueue PackageDisable.new(s_pkg.id), :priority=>0, :run_at=>5.day.from_now
    user.user_delay_job=UserDelayJob.create(:delayed_job_id=>d.id)
    msg="Your Account is about renew  today i.e #{Date.today}. Kindly renew Your account and avoid your account from inactivation."
    user.send_message("Important Alert!",msg);
  end
end