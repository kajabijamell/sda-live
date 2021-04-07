# frozen_string_literal: true

server "example.com", user: "deploy", roles: %w{app db web}

set :branch, 'master'

