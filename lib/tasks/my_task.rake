desc "MY task to call method"


task(:test_name => :environment){ p AdministratorsController.new.user_account_maintenance  }

