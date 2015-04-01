Sequel.migration do
  up do
    create_table :comments do
      primary_key   :id
      Integer       :post_id
      Integer       :user_id
      Text          :body
      Time          :created_at
      Time          :updated_at
    end
  end

  down do
    drop_table :comments
  end
end
