# config/initializers/pdfkit.rb
PDFKit.configure do |config|
  #config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf'
  config.default_options = {
      :page_size => 'Legal',
      :print_media_type => true,
      :margin_top => '0.25in',
      :margin_left => '0.25in',
      :margin_right => '0.25in',
      :margin_bottom => '0.25in'
  }
  config.root_url = "http://localhost" # Use only if your external hostname is unavailable on the server.
end