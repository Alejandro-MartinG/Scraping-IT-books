require 'tweakphoeus'
require 'nokogiri'

class Ebooks
  URL = "https://it-ebooks.info"
  BOOK_URL = "#{URL}/book"
  PUBLISH_URL = "#{URL}/publisher/"
  N_PUBLISHER = 16
  N_BOOKS = 6972


  def initialize
    @http = Tweakphoeus::Client.new()
  end

  def get_urls
    (1..N_BOOKS).each do |number|
      begin
        puts "Book number: #{number.to_s}/#{N_BOOKS}"
        response = @http.get("#{BOOK_URL}/#{number}")
        page = Nokogiri::HTML(response.body)
        table = page.css('.justify > table:nth-child(3)')
        name = table.css('tr')[10].css('a').text
        url = table.css('tr')[10].css('a').attr('href').text
        get_book url, name
      rescue Exception => e
        puts e.message
        puts e.backtrace
        a = File.open("errors_books.csv", "a")
        a.write("ERROR IN ==> #{BOOK_URL}/#{number}")
        a.close
        puts "ERROR IN ==> #{BOOK_URL}/#{number}"
        sleep 1
      end
    end
  end

  def get_book url, name
    puts "url: #{url}, name: #{name}"
    response = @http.get url
    a = File.open("#{name}.pdf","w")
    a.write(response.body)
    a.close
  end

end
