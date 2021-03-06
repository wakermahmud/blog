module Pakyow
  module Console
    module Blog; end
  end
end

require 'pakyow/blog/hooks'
require 'pakyow/blog/schema'
require 'pakyow/blog/version'
require 'pakyow/blog/routes'
require 'pakyow/blog/mutators'
require 'pakyow/blog/mutables'
require 'pakyow/blog/bindings'

Pakyow::Console.plugin :blog do |plugin|
  plugin.version = Pakyow::Console::Blog::VERSION
  plugin.mountable = true
  plugin.routes = :default, :archive, :feed, :show

  boot do
    require 'pakyow/blog/models/post'
  end

  config do
    opt :title, -> { Pakyow::Config.app.name }
    opt :description, -> { Pakyow::Config.app.description }
    opt :language, 'en-US'
  end
end

Pakyow::App.after :load do
  Pakyow::Console::Models::MountedPlugin.where(active: true, name: 'blog').all.each do |mount|
    last_post = Pakyow::Console::Models::Post.where(published: true).first
    modified_date = last_post ? last_post.updated_at : mount.activated_at

    Pakyow::Console.sitemap.url(
      location: File.join(Pakyow::Config.app.uri, mount.slug),
      modified: modified_date.httpdate
    )

    Pakyow::Console.sitemap.url(
      location: File.join(Pakyow::Config.app.uri, mount.slug, 'archive'),
      modified: modified_date.httpdate
    )

    # FIXME: once data sources can differ for a mount point, this will
    # definitely need to be fixed
    Pakyow::Console::Models::Post.where(published: true).each do |post|
      Pakyow::Console.sitemap.url(
        location: File.join(Pakyow::Config.app.uri, mount.slug, post.slug),
        modified: post.updated_at.httpdate
      )
    end
  end
end
