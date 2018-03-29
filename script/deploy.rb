#!/usr/bin/env ruby

require 'dotenv'
Dotenv.load

require_relative '../lib/shared_community_files'

SharedCommunityFiles.deploy
