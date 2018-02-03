Plugin.create :append_url do
  command(:append_url,
          name: _("URLを投稿欄に追加".freeze),
          condition: Proc.new { |opt|
            opt.messages.all?(&:perma_link)
          },
          visible: true,
          role: :timeline) do |opt|
    postbox = Gtk::PostBox.list.first
    text = postbox.widget_post.buffer.text
    if text.length > 0 then
      text = text + "\n".freeze
    end
    urls = opt.messages.reverse.map { |message|
      if message.retweet? then
        message = message.retweet_ancestor
      end
      message.perma_link.to_s
    }.join("\n".freeze)
    postbox.widget_post.buffer.text = text + urls
    postbox.active
  end
end
