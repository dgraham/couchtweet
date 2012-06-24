module Views
  module Sessions
    # Displays the login form with no sidebar.
    class New < Layouts::Application
      def sidebar
        false
      end
    end
  end
end
