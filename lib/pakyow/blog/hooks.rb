Pakyow::Console.before :post, :create do |post|
  post.user = current_console_user
end
