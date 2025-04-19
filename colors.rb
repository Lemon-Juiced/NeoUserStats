require 'json'

# Default ANSI color code for resetting to default
DEFAULT_COLOR = "\e[0m"

# Parse the lang_colors.json file for the given language and get the corresponding color
# @param language [String] The programming language
# @return [String] The color associated with the language
def get_color(language)
  colors = {}

  begin
    # Use an absolute path to the lang_colors.json file
    colors_file = File.expand_path('lang_colors.json', __dir__)
    colors = JSON.parse(File.read(colors_file))
  rescue Errno::ENOENT
    puts "Error: The lang_colors.json file is missing. Please ensure it exists in the same directory."
    return DEFAULT_COLOR # Return the default color if the file is missing
  rescue JSON::ParserError
    puts "Error: The lang_colors.json file is not a valid JSON file."
    return DEFAULT_COLOR # Return the default color if the file is invalid
  end

  # Return the color for the given language or a default color if not found
  return colors[language] || '#000000' # Default to black if language not found
end

# Converts a hex color to an ANSI escape code for terminal colors
# @param hex_color [String] The hex color code
# @return [String] The ANSI escape code for the color
def hex_to_ansi(hex_color)
  if hex_color.match?(/^[0-9a-fA-F]{6}$/) # Ensure it's a valid hex color
    r, g, b = hex_color[0..1].hex, hex_color[2..3].hex, hex_color[4..5].hex
    return "\e[38;2;#{r};#{g};#{b}m"
  else
    return nil # Return nil if the hex color is invalid
  end
end

# Applies the color to the name of the language
# @param language [String] The programming language
# @return [String] The colored language name
def color_lang(language)
  color = get_color(language)
  ansi_code = hex_to_ansi(color)
  if ansi_code
    return "#{ansi_code}#{language}#{DEFAULT_COLOR}"
  else
    return "#{language}" # Fallback to plain text if color is invalid
  end
end