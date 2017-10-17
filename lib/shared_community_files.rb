#!/usr/bin/env ruby

require 'octokit'
require 'yaml'
require 'logger'
require 'active_support/inflector'
require 'forwardable'
require 'memoist'
require 'mustache'
require_relative "shared_community_files/repository"


class SharedCommunityFiles
  class << self
    def client
      @client ||= Octokit::Client.new access_token: ENV['OCTOKIT_ACCESS_TOKEN']
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def def_hash_delegator(hash, key, method = nil)
      define_method(method || key) do
        send(hash)[key.to_s]
      end
    end

    def deploy
      new.deploy
    end
  end

  extend Memoist
  extend Forwardable
  def_delegator :SharedCommunityFiles, :client
  def_delegator :SharedCommunityFiles, :logger

  def_hash_delegator :deploy_config, :repositories
  def_hash_delegator :deploy_config, :installations

  def deploy
    repositories.each do |nwo|
      repo = Repository.new(nwo)
      logger.info "Begining deployment for #{repo.title} (#{repo.nwo})"
      configure_apps(repo)
      configure_branch_protection(repo)
      remove_dotgithub_files(repo)
      setup_dir('.github/', repo)
      setup_dir('docs/', repo)
    end
  end

  private

  def relative_to_root(path)
    File.expand_path("../#{path}", File.dirname(__FILE__))
  end

  # Load YAML file at given path relative to repo root
  def load_yaml(path)
    YAML.load_file File.expand_path("../#{path}", File.dirname(__FILE__))
  end

  def local_dir_files(path)
    Dir[relative_to_root("#{path}*")]
  end

  def settings
    load_yaml('.github/settings.yml')
  end
  memoize :settings

  def deploy_config
    load_yaml('deploy.yml')
  end
  memoize :deploy_config

  def configure_apps(repo)
    logger.info '=> Configuration Apps'
    installations.each do |label, installation|
      logger.info "==> Installing #{label}"
      options = { accept: 'application/vnd.github.machine-man-preview+json' }
      client.add_repository_to_app_installation installation, repo.id, options
    end
  end

  def configure_branch_protection(repo)
    logger.info '=> Setting branch protection'
    options = { accept: 'application/vnd.github.loki-preview+json' }
    options = options.merge settings['branch_protection']

    # Not 100% sure why, but unless you symbolize the `required_status_checks` key
    # Octokit fails to set required status contexts for some reason
    options = options.each_with_object({}) { |(k, v), memo| memo[k.to_sym] = v; }

    client.protect_branch repo.nwo, 'master', options
  end

  # Removes files from `.github/` that should live in `docs/`
  def remove_dotgithub_files(repo)
    local_dir_files("docs/").each do |file|
      basename = File.basename(file)
      path = File.join ".github/", basename
      repo.delete_file(path) if repo.file_exists?(path)
    end
  end

  def setup_dir(dir, repo)
    logger.info "=> Setting #{dir} contents"
    local_dir_files(dir).each do |file|
      path = File.join dir, File.basename(file)
      content = render(path, repo)
      repo.set_file_contents(path, content)
    end
  end

  def template_contents(template_path)
    abspath = File.expand_path "../#{template_path}", File.dirname(__FILE__)
    File.read(abspath)
  end
  memoize :template_contents

  def render(template_path, repo)
    Mustache.render template_contents(template_path), {
      nwo: repo.nwo,
      title: repo.title,
      custom_contributing_content: repo.custom_contributing_content,
      has_support: repo.has_support?,
      has_troubleshooting: repo.has_troubleshooting?
    }
  end
end
