module Views
  module Layouts
    # This is the base class for all other mustache views. If a method is
    # needed for the layouts/application.mustache template, add it here,
    # otherwise it should live in ApplicationHelper.
    class Application < ActionView::Mustache
      include ApplicationHelper
      include DateHelper
      include GravatarHelper
      include TweetHelper

      attr_reader :current_user
      attr_reader :user

      def page_title
        'CouchTweet'
      end

      def link_to_home
        link_to('Home', root_path)
      end

      def link_to_login
        link_to('Sign in', new_session_path)
      end

      def link_to_logout
        link_to('Sign out', logout_path)
      end

      def link_to_profile
        link_to('Profile', current_user_path)
      end

      def link_to_logo
        link_to(image_tag('logo.svg', alt: 'CouchTweet'), root_path)
      end

      def body_class
        sidebar ? '' : 'class="narrow"'.html_safe
      end

      def sidebar
        @sidebar ||= user_sidebar
      end

      def user_sidebar
        Mustache.render_file('app/templates/users/_sidebar', self)
      end

      def welcome_sidebar
        Mustache.render_file('app/templates/welcome/_sidebar', self)
      end

      def stylesheets
        stylesheet_link_tag('application', media: 'all')
      end

      def javascripts
        javascript_include_tag('application')
      end
    end
  end
end
