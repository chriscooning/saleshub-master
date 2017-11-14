namespace :external_news do
  task scan: :environment do

    rss_feed_uris = %q{
      http://www.thepacker.com/fruit-vegetable-news/index.rss
      http://www.thepacker.com/fruit-vegetable-news/produce-industry-leaders/Rising_Stars/index.rss
      http://www.thepacker.com/fruit-vegetable-news/foodservice/index.rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Taylor+Farms&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Pma&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Packer&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Yum&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Panera&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Chipotle&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Burger+King&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Del+Taco&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Subway&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Sysco&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=US+Foods&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Markon&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Amerifresh&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Produce+Alliance&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Performance+Food+Group&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Earthbound+Farms&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Church+Brothers&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Church+Brothers&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Green+Gate&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Tanamura+Antle&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=True+Leaf&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Fresh+Express&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Dole&output=rss
      https://news.google.com/news/feeds?pz=1&cf=all&ned=us&hl=en&q=Food+trends&output=rss
      http://www.wga.com/blog/rss
    }.split

    Services::ExternalNews.new.scan(rss_feed_uris)
  end

  task clean: :environment do
    offset = 0

    ordered = NewsEntry.where(news_type: NewsEntry::Types::EXTERNAL).order('id ASC')

    loop do
      entry = ordered.offset(offset).limit(1).first

      break unless entry.present?

      puts %Q[Start process entry with ID: "#{entry.id}" and TITLE: "#{entry.title}"]

      suspects = ordered.where('id > ?', entry.id).where(title: entry.title)

      body = ActionController::Base.helpers.strip_tags(entry.body).strip.downcase
      guid = entry.guid.to_s.strip.downcase

      if suspects.present?
        puts %Q[  #{suspects.count} suspicious #{'entries'.pluralize(suspects.count)} #{'was'.pluralize(suspects.count)} found]

        guilty = suspects.select do |suspect|
          (body.present? && ActionController::Base.helpers.strip_tags(suspect.body).strip.downcase.eql?(body)) ||
          (guid.present? && suspect.guid.to_s.strip.downcase.eql?(guid))
        end

        puts %Q[  #{guilty.count} suspicious #{'entries'.pluralize(suspects.count)} #{'was'.pluralize(suspects.count)} identified as clones]
        unless guilty.count.zero?
          guilty.each(&:destroy)
          prisoners = guilty.select(&:destroyed?)

          puts %Q[    #{prisoners.count} #{'clone'.pluralize(prisoners.count)} #{'was'.pluralize(prisoners.count)} destroyed]
        end
      else
        puts %Q[  Suspicious entries was not found]
      end

      puts %Q[Finish process entry]
      puts ''

      offset += 1
    end
  end

  task update: :environment do
    scope = NewsEntry.external.where('link LIKE ?', '%news.google.com%')

    scope.each do |entry|
      uri = entry.link
      query = uri.present? ? URI.parse(uri).query : nil
      url = query.present? ? CGI.parse(query)['url'].try(:last) : nil

      if url.present?
        entry.update_column(:guid, "tag:news.google.com,2005:cluster=#{url}")
      end
    end

    scope = NewsEntry.external.where(pub_date: nil)

    scope.each do |entry|
      entry.update_column(:pub_date, entry.created_at)
    end
  end
end
