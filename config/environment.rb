require 'bundler'
require 'net/http'
require 'json'
require 'uri'
require 'dotenv'
require 'pry'
require 'colorize'

Bundler.require

Dotenv.load('config/.env')

require_all 'lib'