Sequel.migration do
  up do
    create_table :posts do
      primary_key   :id
      Integer       :user_id
      String        :title
      Text          :body
      FalseClass     :published, default: false
      Time          :published_at
      Time          :created_at
      Time          :updated_at
    end
  end

  down do
    drop_table :posts
  end
end
