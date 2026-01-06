class FeedController < ApplicationController
  require "mp3info"

  def index
    xml_content = channel_xml + episode_xml + closing_xml

    render xml: xml_content
  end

  private

  def channel_xml
    podcast_url = "#{request.base_url}/feed"
    podcast_title = ENV['PODCAST_TITLE']
    build_date = Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")
    copyright = "© #{Time.now.strftime("%Y")} #{ENV['PODCAST_AUTHOR']}"
    guid = SecureRandom.uuid
    author = ENV['PODCAST_AUTHOR']
    description = ENV['PODCAST_DESCRIPTION']

    <<~XML
    <?xml version="1.0" encoding="UTF-8" ?>
    <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:podcast="https://podcastindex.org/namespace/1.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:psc="http://podlove.org/simple-chapters" xmlns:atom="http://www.w3.org/2005/Atom">
    <channel>
      <atom:link href="#{podcast_url}" rel="self" type="application/rss+xml" />
      <title>#{podcast_title}</title>
      <lastBuildDate>#{build_date}</lastBuildDate>
      <language>en-us</language>
      <copyright>#{copyright}</copyright>
      <podcast:locked>yes</podcast:locked>
      <podcast:guid>#{guid}</podcast:guid>
      <itunes:author>#{author}</itunes:author>
      <itunes:type>episodic</itunes:type>
      <itunes:explicit>false</itunes:explicit>
      <description><![CDATA[<p>#{description}</p>]]></description>
      <itunes:owner>
        <itunes:name>#{author}</itunes:name>
      </itunes:owner>
      XML
  end

  def closing_xml
    <<~XML
    </channel>
    </rss>
    XML
  end

  def episode_xml
    result = ''
    supported_filetypes = [".mp3", ".mp4"]

    # when running via docker, /media will be mapped to some local volume
    Dir.glob("#{ASSETS_DIR}/*").each do |file|
      filename = File.basename(file)
      mp3 = Mp3Info.open(file) rescue nil
      next if !supported_filetypes.any?{|ext| filename.include?(ext)}

      pubDate = Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")
      author = mp3&.tag&.artist || ENV['PODCAST_AUTHOR']
      title = mp3&.tag&.title || filename
      description = mp3&.tag&.title || "Description of #{filename}"
      length = File.size(file)
      duration = mp3.length.to_i || 1
      type = "audio/mpeg"
      file_url = "#{request.base_url}/assets/#{filename}"

      result << <<~XML
        <item>
        <itunes:title>#{title}</itunes:title>
        <title>#{title}</title>
        <itunes:summary><![CDATA[#{description} ]]></itunes:summary>
        <description><![CDATA[<p>#{description}</p>]]></description>
        <content:encoded><![CDATA[<p>#{description}</p>]]></content:encoded>
        <itunes:author>#{author}</itunes:author>
        <enclosure url="#{file_url}" length="#{length}" type="#{type}" />
        <guid isPermaLink="false">#{filename}</guid>
        <pubDate>#{pubDate}</pubDate>
        <itunes:duration>#{duration}</itunes:duration>
        <itunes:keywords></itunes:keywords>
        <itunes:episodeType>full</itunes:episodeType>
        <itunes:explicit>false</itunes:explicit>
        </item>
        XML
    end

    result
  end
end
