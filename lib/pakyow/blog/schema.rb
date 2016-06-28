Pakyow::Console.data :post, icon: 'newspaper-o' do
  model 'Pakyow::Console::Models::Post'
  pluralize

  attribute :title, :string
  attribute :body, :content
  attribute :published_at, :datetime, nice: 'Publish Date'

  action :publish,
         label: 'Publish',
         notification: 'post published',
         display: ->(post) { !post.published? } do |post|
    post.published = true
    post.published_at = Time.now unless post.published_at
    post.save
  end

  action :unpublish,
         label: 'Unpublish',
         notification: 'post unpublished',
         display: ->(post) { post.published? } do |post|
    post.published = false
    post.save
  end

  action :delete, label: 'Delete' do |post|
    post.destroy
    notify("#{post.title} post deleted", :success)
    redirect router.group(:data).path(:show, data_id: params[:data_id])
  end
end
