desc "Index all users for user bio and custom fields"
task "xypn:indexAll" => :environment do
	User.find_each do |user|
		puts "Indexing #{user.username}"
  	SearchIndexer.update_users_index(user.id, user.username_lower || '', user.name ? user.name.downcase : '')
		sleep(2)
  	puts "Indexed #{user.username}"
	end
end

desc "Index a user for user bio and custom fields"
task "xypn:indexUser", [:username] => [:environment] do |_, args|
	user = find_user(args[:username])
	puts "Indexing #{user.username}"
	SearchIndexer.update_users_index(user.id, user.username_lower || '', user.name ? user.name.downcase : '')
	puts "Indexed #{user.username}"
end
