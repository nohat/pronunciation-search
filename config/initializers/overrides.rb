# encoding: UTF-8
# Prevent utf8=✓ param in GET forms.
module ActionView::Helpers::FormTagHelper
private
  def extra_tags_for_form_with_snowman_excluded_from_gets(html_options)
    snowman_tag = tag(:input, :type => "hidden",
                      :name => "utf8", :value => "✓".html_safe)

    authenticity_token = html_options.delete("authenticity_token")
    method = html_options.delete("method").to_s

    tags = case method
      when /^get$/ # must be case-insensitive, but can't use downcase as might be nil
        html_options["method"] = "get"
        ''
      when /^post$/, "", nil
        html_options["method"] = "post"
        snowman_tag + token_tag(authenticity_token)
      else
        html_options["method"] = "post"
        snowman_tag + tag(:input, :type => "hidden", :name => "_method", :value => method) + token_tag(authenticity_token)
    end
    content_tag(:div, tags, :style => 'margin:0;padding:0;display:inline')
  end
  alias_method_chain :extra_tags_for_form, :snowman_excluded_from_gets
end