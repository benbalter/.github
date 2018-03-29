class SharedCommunityFiles
  class Repository
    attr_reader :nwo

    extend Memoist
    extend Forwardable
    def_delegator :SharedCommunityFiles, :client
    def_delegator :SharedCommunityFiles, :logger
    def_delegator :repo_info, :id

    TITLE_SUBSTITUTIONS = {
      "Wp"        => "WP",
      "Wordpress" => "WordPress",
      "Github"    => "GitHub"
    }

    def initialize(nwo)
      @nwo = nwo
    end

    def repo_info
      client.repository nwo
    end
    memoize :repo_info

    def title
      pattern = Regexp.union(TITLE_SUBSTITUTIONS.keys)
      nwo.split("/").last.titleize.gsub(pattern, TITLE_SUBSTITUTIONS)
    end

    def files(path)
      client.contents nwo, path: path
    rescue Octokit::NotFound
      {}
    end
    memoize :files

    def file_exists?(path)
      dir = File.dirname(path)
      files(dir).any? { |f| f.path == path }
    end

    def get_file_contents(path)
      response = blob(path)
      Base64.decode64(response.content).force_encoding('utf-8')
    end

    def set_file_contents(path, content)
      if file_exists?(path)
        if content == get_file_contents(path)
          logger.info "==> #{path} already exists and is up to date. Skipping."
        else
          logger.warn "==> #{path} already exists but it out of date. Ovewriting."
          blob = blob(path)
          client.update_contents nwo, path, "Update #{path}", blob.sha, content
        end
      else
        logger.info "==> Creating #{path}"
        client.create_contents nwo, path, "Create #{path}", content
      end
    end

    def delete_file(path)
      return unless file_exists?(path)
      logger.info "==> Deleting #{path}"
      blob = blob(path)
      client.delete_contents nwo, path, "Delete #{path}", blob.sha
    end

    def blob(path)
      client.contents nwo, path: path
    end
    memoize :blob

    def custom_contributing_content
      path = File.expand_path "../../contributing/#{nwo}.md", File.dirname(__FILE__)
      File.read(path) if File.exists?(path)
    end

    def has_support?
      file_exists?("docs/SUPPORT.md")
    end

    def has_troubleshooting?
      file_exists?("docs/troubleshooting.md")
    end
  end
end
