# name: discourse-xypn-search-customization-plugin
# version: 1.0
# author: Procourse
# url: https://github.com/procourse/discourse-xypn-search-customization-plugin

after_initialize do
  SearchIndexer.class_eval do
    def self.update_users_index(user_id, username, name)
      user = User.find(user_id)
      custom_field_content = []
      fields = ["user_field_2", "user_field_3", "user_field_4"]
      bio = user.user_profile.bio_raw ? user.user_profile.bio_raw.downcase : ''
      custom_field_content.push(username, name, bio)

      # Add custom field content to the index
      UserCustomField.where(user_id: user_id).each do |custom_field|
        if fields.include? custom_field.name
          custom_field_content.push(custom_field.value)
        end
      end

      update_index(table: 'user', id: user_id, raw_data: custom_field_content)
    end
  end

  # Index users on profile update including custom field changes
  DiscourseEvent.on(:user_updated) do |obj|
    SearchIndexer.update_users_index(obj.id, obj.username_lower || '', obj.name ? obj.name.downcase : '')
  end
end
