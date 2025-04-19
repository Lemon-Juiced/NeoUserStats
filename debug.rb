require_relative 'colors'
require_relative 'github_api'
require_relative 'debug' # Require the new debug file

def main
  # Check for the -c flag
  if ARGV.include?('-c')
    debug_colors
    return
  end

  # Initialize the Octokit client
  client = get_client()

  # Check if a username is passed as a command-line argument
  username = ARGV[0]
  if username.nil? || username.strip.empty?
    # Ask for the username if not provided as an argument
    puts "Enter a GitHub username:"
    username = gets.chomp
  end

  # Cache for repositories and stats
  repo_stats_cache = {}

  # Get basic user information
  get_user_info(client, username)

  # Store a list of repositories for the user
  puts "\nFetching repositories..."
  repos = get_user_repos(client, username)
  puts "Repositories for #{username}: #{repos.join(', ')}"

  # Get repository statistics for each repository and store them in the cache
  repos.each do |repo|
    puts "\nFetching stats for repository #{repo}..."
    repo_stats_cache[repo] = get_repo_stats(client, username, repo)
  end

  # Use the cached stats to calculate total lines of code per language
  language_lines = {}
  repo_stats_cache.each do |repo, stats|
    stats.each do |language, lines|
      language_lines[language] = language_lines.fetch(language, 0) + lines
    end
  end

  # Print the total lines of code per language
  puts "\nTotal lines of code per language across all repositories:"
  language_lines.each do |language, total_lines|
    puts "#{color_lang(language)}: #{total_lines} lines"
  end

  # Calculate and print the sum of all lines of code
  total_lines_of_code = language_lines.values.sum
  puts "\nTotal lines of code across all repositories: #{total_lines_of_code} lines"

  # Now that we have the total lines of code, we can calculate the percentage of each language
  puts "\nPercentage of lines of code per language:"
  language_lines.each do |language, total_lines|
    percentage = (total_lines.to_f / total_lines_of_code * 100).round(2)
    puts "#{color_lang(language)}: #{percentage}%"
  end

  puts "\nDone!"
end

# Calls the main function if this file is executed directly
main if __FILE__ == $PROGRAM_NAME