module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name, routing=nil)
    case page_name
    
    when /the homepage/
      '/'
    
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    # added by script/generate pickle path
    when /the newsletter archive page/
      "/newsletters/archive"
    when /newsletter named "([^"]+)"'s new piece page$/
      newsletter_name = $1
      newsletter = Newsletter::Newsletter.where(name: newsletter_name).first
      "/newsletter/newsletters/#{newsletter.id}/pieces/new"

    when /^the (.+?) page$/                                         # translate to named route
      routing.send("#{$1.downcase.gsub(' ','_')}_path")
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
