module Pakyow::Helpers
  def authed?
    !session[:user].nil?
  end

  def auth(user)
    session[:user] = user.id
  end

  def unauth
    session[:user] = nil
  end

  def current_user
    Pakyow::Auth::User[session[:user]]
  end

  def mixin_view(path)
    if store(:default).at?(path)
      presenter.view = store(:default).composer(path)
    else
      # use the user's template
      #TODO use the configured default template
      template = store(:default).template(:pakyow)
      presenter.view = Presenter::ViewComposer.new(store(:auth), path, { template: template })
    end
  end
end
