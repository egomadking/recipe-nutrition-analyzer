require 'bundler'
require 'net/http'
require 'json'
require 'uri'
require 'dotenv'

Bundler.require

Dotenv.load('config/.env')

require_all 'lib'