Pakyow::App.bindings :'pw-post' do
  scope :'pw-post' do
    binding :'show-link' do
      part :href do
        File.join('/', context.current_plugin.slug, bindable.slug)
      end

      part :content do
        bindable.title
      end
    end

    binding :permalink do
      part :href do
        File.join('/', context.current_plugin.slug, bindable.slug)
      end

      part :content do
        bindable.published_at.strftime('%d %B %Y')
      end
    end

    binding :published_at do |value|
      part :content do
        value.strftime('%d %B %Y')
      end
    end

    binding :author do
      part :content do
        bindable.user.username if bindable.user
      end
    end

    binding :'share-fb' do
      part :href do
        "https://www.facebook.com/sharer/sharer.php?u=#{File.join(config.app.uri, context.current_plugin.slug, bindable.slug)}"
      end
    end

    binding :'share-t' do
      part :href do
        "https://twitter.com/home?status=#{bindable.title}+-+#{File.join(config.app.uri, context.current_plugin.slug, bindable.slug)}"
      end
    end

    binding :'share-hn' do
      part :href do
        "https://news.ycombinator.com/submitlink?u=#{File.join(config.app.uri, context.current_plugin.slug, bindable.slug)}&t=#{bindable.title}"
      end
    end

    binding :'share-r' do
      part :href do
        "http://www.reddit.com/submit?url=#{File.join(config.app.uri, context.current_plugin.slug, bindable.slug)}"
      end
    end
  end
end
