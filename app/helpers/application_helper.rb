module ApplicationHelper

  def display_premium_status
    if current_user.premium?
      content_tag :p, "You are a premium user."
    else
      content_tag :p, "You are a standard user."
    end
  end

  def markdown_to_html(markdown)
    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    (redcarpet.render markdown).html_safe
  end

end
