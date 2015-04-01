module Pakyow::Auth::Routes
  include Pakyow::Routes
  include Pakyow::Routes::Restful

  get :login, '/login' do
    reroute invoke(:auth, :login)
  end

  get :logout, '/logout' do
    invoke(:auth, :logout)
    redirect config.auth.redirect_unauth
  end

  #TODO fix restful routes not being available to mixins
  namespace :session, '/sessions' do
    get :new, '/sessions/new' do
      redirect config.auth.redirect_authed if authed?
      invoke(:auth, :login)
    end

    post :create, '/sessions' do
      invoke(:auth, :perform)
      redirect config.auth.redirect_authed
    end
  end
end
