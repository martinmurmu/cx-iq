namespace :migration do
  desc "migrate oem_user into users"
  task :oem_user => :environment do |rake_task|
      migrate_oem_user_into_users
  end

  def migrate_oem_user_into_users
    OemUser.find_in_batches(:batch_size => 100) do |users|
      users.each { |oem_user|
        begin
        u = User.new(
                :email => oem_user.email,
                :last_name => oem_user.last_name,
                :first_name => oem_user.first_name,
                :password => oem_user.password
                )
        u.id = oem_user.id
        u.save!
        u.reload
        #u.clean_up_passwords
        #u.password=oem_user.password
        u.confirm!
        u.save!
        rescue Exception => e
          puts e
        end
      }

    end
  end

end
