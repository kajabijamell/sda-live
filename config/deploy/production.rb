# frozen_string_literal: true

server 'ec2-13-59-195-103.us-east-2.compute.amazonaws.com', user: 'ubuntu', roles: %w[app db web]

set :branch, 'master'

