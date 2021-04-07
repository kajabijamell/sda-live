# frozen_string_literal: true
# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server 'ec2-18-222-159-252.us-east-2.compute.amazonaws.com', user: 'ubuntu', roles: %w[app db web]

set :branch, 'staging'



