require 'octokit'

# Gets the client for GitHub API
# 
# @return [Octokit::Client] The Octokit client instance
def get_client() 
  puts "Initializing Octokit client..."
  return Octokit::Client.new()
end

# Gets the basic user information for a given username
# 
# @param client [Octokit::Client] The Octokit client instance
# @param username [String] The GitHub username
def get_user_info(client, username)
  begin
    puts "Fetching user info for #{username}..."
    user = client.user(username)
    puts "Name: #{user.name}"
  rescue Octokit::Error => e
    puts "Error fetching user info: #{e.message}"
  end
end

# Return a list of repositories for a user
# 
# @param client [Octokit::Client] The Octokit client instance
# @param username [String] The GitHub username
# 
# @return [Array] List of repositories for the user
def get_user_repos(client, username)
  begin
    puts "Fetching repositories for #{username}..."
    repos = client.repositories(username)
    return repos.map(&:name)
  rescue Octokit::Error => e
    puts "Error fetching repositories: #{e.message}"
    return []
  end
end

# Get repository stats for a given repository
# 
# @param client [Octokit::Client] The Octokit client instance
# @param owner [String] The owner of the repository
# @param repo [String] The repository name in the format "owner/repo"
# 
# @return [Hash] Repository statistics including languages and number of lines of code per language
def get_repo_stats(client, owner, repo)
  begin
    full_repo_name = "#{owner}/#{repo}" # Combine owner and repo into the required format
    puts "Fetching repository stats for #{full_repo_name}..."
    stats = client.languages(full_repo_name)

    # Convert the Sawyer::Resource object to a hash for caching
    stats_hash = stats.to_h
    stats_hash.each do |language, lines|
      puts "#{language}: #{lines} lines of code"
    end
    return stats_hash
  rescue Octokit::Error => e
    puts "Error fetching repository stats: #{e.message}"
    return {}
  end
end