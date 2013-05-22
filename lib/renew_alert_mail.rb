# To change this template, choose Tools | Templates
# and open the template in the editor.


class RenewAlertMail < Struct.new(:u_id)
  def perform
    user=User.find(u_id)
    if user.balance >= user.selected_package.price
      user.balance -= user.selected_package.price
      user.save
      user.selected_package.renew_package
      msg="Your have Renewed automatically."
      user.send_message("Informing Account Renew",msg);
    else
    user.destroy_delay_job
    d=Delayed::Job.enqueue InactivationAlert.new(u_id), :priority=>0, :run_at=>5.day.from_now
    user.user_delay_job=UserDelayJob.create(:delayed_job_id=>d.id)
    msg="Your Account is about to expire on #{Date.today+5}. Kindly renew Your account in time and avoid your account from inactivation."
    user.send_message("Important Alert!",msg);
    end
  end
end