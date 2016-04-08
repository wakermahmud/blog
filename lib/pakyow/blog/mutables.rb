Pakyow::App.mutable :'pw-post' do
  query :published do
    Pakyow::Console::Models::Post.where(published: true).limit(15).all
  end

  query :grouped do
    groups = Pakyow::Console::Models::Post.where(published: true).all.group_by { |p|
      "#{p.published_at.year}-#{p.published_at.month}"
    }.to_a.sort{|a,b| b[0] <=> a[0] }
  end
end
