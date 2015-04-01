BLOG_ROOT = File.expand_path('../', __FILE__)

Pakyow::App.config.presenter.view_stores[:auth] = File.join(BLOG_ROOT, 'views')

module Pakyow
  module Blog
  end
end

require_relative 'version'

Pakyow::Console::Plugins.register :blog do |plugin|
  plugin.version = Pakyow::Blog::VERSION
  plugin.mountable = true

  boot do
    require_relative 'post_model'
    require_relative 'comment_model'
  end

  config do
    # opt :redirect_unauth, lambda { Pakyow::Router.instance.path(:default) }
    # opt :redirect_authed, lambda { Pakyow::Router.instance.path(:default) }
  end

  # function :login do
  #   mixin_view('sessions/new')
  #   view.scope(:session).bind(@session || {})
  #   handle_errors(view)
  # end

  # function :logout do
  #   unauth
  # end

  # function :perform do
  #   @session = params[:session]
  #   if user = Pakyow::Auth::User.authenticate(@session)
  #     auth(user)
  #   else
  #     @errors = ['Invalid email and/or password']
  #     invoke(:auth, :login)
  #     halt
  #   end
  # end
end

Pakyow::Console::Data.register :post do |datatype|
  datatype.model = 'Pakyow::Blog::Post'

  related_to :comments
  related_to :user, as: :author

  reference do |post|
    post.title
  end

  attribute :title, :string
  attribute :body, :content
  attribute :published, :boolean
  attribute :published_at, :datetime
end

Pakyow::Console::Data.register :comment do |datatype|
  datatype.model = 'Pakyow::Blog::Comment'

  related_to :post
  related_to :user, as: :author

  reference do |comment|
    comment.id
  end

  attribute :body, :markdown
end
