module Pakyow
  module Console
    module Plugins
      module Blog
        module Routes
          include Pakyow::Routes

          template :blog do
            default do
              view.title = "#{config.app.name} - Blog"

              # TODO: we need support for pagination; perhaps baked into console
              view.scope(:'pw-post').mutate(:list, with: data(:'pw-post').published)

              # TODO: we could support versioning out of the box by defining an attribute of the post
              # or metadata to set the type (e.g. how I did it without console); this would avoid some
              # complex UI and instead just make it part of the data

              # TODO: if you wanted to replace or augment the rendering, how would you do it?
              # one way might be to redefine the pw-post#list mutator; but on second thought that might
              # replace all the defined mutations; alternatively we could create business objects
              # that could have aspects of them replaced; this is pretty low priority
              #
              # one way to do it would be to define special rendering logic for a particular version
            end

            get :show, '/:slug' do
              post = Pakyow::Console::Models::Post.first(slug: String.normalize_path(params[:slug]))

              if post.nil? || !post.published
                Pakyow::Console.handle_slug(self)
              else
                view.title = "#{config.app.name} - #{post.title}"
                view.scope(:'pw-post').mutate(:show, with: post)
              end
            end

            get :archive, '/archive' do
              view.title = "#{config.app.name} - Archive"
              view.scope(:'pw-post-group').mutate(:archive, with: data(:'pw-post').grouped)
            end

            get :feed, '/feed' do
              posts = data(:'pw-post').published.data
              blog_url = File.join(config.app.uri, current_plugin.slug)

              feed = Oga::XML::Document.new(type: :xml, xml_declaration: Oga::XML::XmlDeclaration.new(version: 1.0, encoding: 'UTF-8'))

              rss = Oga::XML::Element.new(name: :rss)
              rss.set('version', '2.0')
              rss.set('xmlns:atom', 'http://www.w3.org/2005/Atom')

              channel = Oga::XML::Element.new(name: :channel)

              title = Oga::XML::Element.new(name: 'title')
              title.inner_text = current_plugin.config['title']
              channel.children << title

              description = Oga::XML::Element.new(name: 'description')
              description.inner_text = current_plugin.config['description']
              channel.children << description

              link = Oga::XML::Element.new(name: 'link')
              link.inner_text = blog_url
              channel.children << link

              language = Oga::XML::Element.new(name: 'language')
              language.inner_text = current_plugin.config['language'] || config.blog.language
              channel.children << language

              unless posts.empty?
                last_build = Oga::XML::Element.new(name: 'lastBuildDate')
                last_build.inner_text = posts.first.published_at.httpdate
                channel.children << last_build
              end

              generator = Oga::XML::Element.new(name: 'generator')
              generator.inner_text = "Pakyow Console #{Pakyow::Console::VERSION}"
              channel.children << generator

              atom_link = Oga::XML::Element.new(name: 'atom:link')
              atom_link.set('href', blog_url)
              atom_link.set('rel', 'self')
              atom_link.set('type', 'application/rss+xml')
              channel.children << atom_link

              posts.each do |post|
                post_element = Oga::XML::Element.new(name: 'item')

                title = Oga::XML::Element.new(name: 'title')
                title.children << Oga::XML::Cdata.new(text: post.title)
                post_element.children << title

                link = Oga::XML::Element.new(name: 'link')
                link.inner_text = File.join(blog_url, post.slug)
                post_element.children << link

                pub_date = Oga::XML::Element.new(name: 'pubDate')
                pub_date.inner_text = post.published_at.httpdate
                post_element.children << pub_date

                guid = Oga::XML::Element.new(name: 'guid')
                guid.inner_text = File.join(blog_url, post.slug)
                guid.set('isPermaLink', 'true')
                post_element.children << guid

                description = Oga::XML::Element.new(name: 'description')
                description.children << Oga::XML::Cdata.new(text: post.html)
                post_element.children << description

                channel.children << post_element
              end

              rss.children << channel
              feed.children << rss

              send feed.to_xml, 'application/rss+xml'
            end
          end
        end
      end
    end
  end
end
