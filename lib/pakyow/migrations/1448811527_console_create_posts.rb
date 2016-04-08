Sequel.migration do
  up do
    create_table :'pw-posts' do
      primary_key   :id
      foreign_key   :user_id, :'pw-users'
      String        :title
      String        :slug
      json          :tags
      json          :metadata
      json          :config
      FalseClass    :published, default: false
      Time          :published_at
      Time          :created_at
      Time          :updated_at
    end
  end

  down do
    drop_table :'pw-posts'
  end
end
