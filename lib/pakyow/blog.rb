Pakyow::Console.plugin :blog do |plugin|
  plugin.version = Pakyow::Blog::VERSION
  plugin.mountable = true
  plugin.routes = :default, :archive, :feed, :show

  boot do
    require 'pakyow/blog/models/post'
  end

  config do
    opt :title
    opt :description
    opt :language, 'en-US'
  end
end

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
