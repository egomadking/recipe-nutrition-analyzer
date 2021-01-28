require 'bundler'
require 'net/http'
require 'json'
require 'uri'
require 'dotenv'
require 'pry'

Bundler.require

Dotenv.load('config/.env')

require_all 'lib'