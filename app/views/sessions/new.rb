module Views
  module Sessions
    # Displays the login form with no sidebar.
    class New < Layouts::Application

      def page_id
        'login-page'
      end

      def sidebar
        false
      end
    end
  end
end
