require 'resque'
require 'resque/tasks'

# load rails before working
task 'resque:setup' => :environment
