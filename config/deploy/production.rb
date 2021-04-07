# frozen_string_literal: true

server 'ec2-18-219-133-25.us-east-2.compute.amazonaws.com', user: 'ubuntu', roles: %w[app db web]

set :branch, 'master'

