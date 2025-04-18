require_relative 'lib/github_api'

def main
  # Initialize the Octokit client
  client = get_client()

  # Check if a username is passed as a command-line argument
  username = ARGV[0]
  if username.nil? || username.strip.empty?
    # Ask for the username if not provided as an argument
    puts "Enter a GitHub username:"
    username = gets.chomp
  end

  # Get basic user information
  get_user_info(client, username)

  # Store a list of repositories for the user
  puts "\nFetching repositories..."
  repos = get_user_repos(client, username)
  puts "Repositories for #{username}: #{repos.join(', ')}"

  # Get repository statistics for each repository
  repos.each do |repo|
    puts "\nFetching stats for repository #{repo}..."
    get_repo_stats(client, username, repo) # No need to process the return value
  end

  puts "\nDone!"
end

# Calls the main function if this file is executed directly
main if __FILE__ == $PROGRAM_NAME