Pakyow::Console.data :post, icon: 'newspaper-o' do
  model 'Pakyow::Console::Models::Post'
  pluralize

  attribute :title, :string
  attribute :slug, :string, nice: 'Post Path', display: -> (post) {
    !post.nil? && !post.id.nil?
  }
  attribute :body, :content
  attribute :published_at, :datetime, nice: 'Publish Date', display: -> (post) {
    !post.nil? && !post.id.nil?
  }

  action :publish,
         label: 'Publish',
         notification: 'post published',
         display: ->(post) { !post.published? } do |post|
    post.published = true
    post.published_at = Time.now unless post.published_at
    post.save

    Pakyow::Console.sitemap.url(
      location: File.join(Pakyow::Config.app.uri, post.slug),
      modified: post.updated_at.httpdate
    )
  end

  action :unpublish,
         label: 'Unpublish',
         notification: 'post unpublished',
         display: ->(post) { post.published? } do |post|
    post.published = false
    post.save

    Pakyow::Console.sitemap.delete_location(
      File.join(Pakyow::Config.app.uri, post.slug)
    )
  end

  action :delete, label: 'Delete' do |post|
    post.destroy
    notify("#{post.title} post deleted", :success)

    Pakyow::Console.sitemap.delete_location(
      File.join(Pakyow::Config.app.uri, post.slug)
    )

    redirect router.group(:data).path(:show, data_id: params[:data_id])
  end
end

Pakyow::Console.after :post, :create do |post|
  if post.published?
    Pakyow::Console.sitemap.url(
      location: File.join(Pakyow::Config.app.uri, post.slug),
      modified: post.updated_at.httpdate
    )
  end
end

Pakyow::Console.after :post, :update do |post|
  if post.published?
    Pakyow::Console.sitemap.delete_location(
      File.join(Pakyow::Config.app.uri, post.initial_value(:slug))
    )

    Pakyow::Console.sitemap.url(
      location: File.join(Pakyow::Config.app.uri, post.slug),
      modified: post.updated_at.httpdate
    )
  end
end
