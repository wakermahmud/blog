module Pakyow
  module Console
    module Models
      class Post < Sequel::Model(Pakyow::Config.app.db[:'pw-posts'].order(Sequel.desc(:published_at)))
        one_to_many :content, as: :owner
        add_association_dependencies content: :destroy
        many_to_one :user

        MONTHS = {
          '1' => 'January',
          '2' => 'February',
          '3' => 'March',
          '4' => 'April',
          '5' => 'May',
          '6' => 'June',
          '7' => 'July',
          '8' => 'August',
          '9' => 'September',
          '10' => 'October',
          '11' => 'November',
          '12' => 'December'
        }

        def body
          content.first
        end

        def body=(content)
          @body = content
        end

        def before_save
          # TODO: on create we need to avoid slug collisions with other things in console
          @values[:slug] ||= String.slugify(title)
        end

        def after_save
          unless @body.nil?
            body = self.body || Pakyow::Console::Models::Content.new(owner: self)
            body.content = @body
            body.save
          end

          super
        end

        def published?
          published == true
        end

        def html
          renderer_view = Pakyow.app.presenter.store(:console).view('/console/pages/template')
          rendered = renderer_view.scope(:content)[0]
          Pakyow::Console::ContentRenderer.render(body.content, view: rendered).to_html
        end
      end
    end
  end
end
