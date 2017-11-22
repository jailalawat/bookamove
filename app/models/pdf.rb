require 'render_anywhere'
class Pdf
  include RenderAnywhere
  PROPOSAL = 1
  CONTRACT = 2
  INVOICE = 3
  RECEIPT = 4

  DOCUMENT_TYPES = [["", ""], ["Proposal", "Move Proposal"], ["Contract", "Move Contract"], ["Invoice", "Move Invoice"], ["Receipt", "Move Receipt"]]

  LOCAL = 1
  LONG_DISTANCE = 2
  MOVE_TYPES = ["", "Local", "Long Distance"]

  def self.document_title(move, document_type, dashed)
    return "#{ !move.move_type_id.blank? ? Pdf::MOVE_TYPES[move.move_type_id] : 'Local'}#{ dashed ? "_" : " "}#{document_type and Pdf::DOCUMENT_TYPES[document_type.to_i] ? Pdf::DOCUMENT_TYPES[document_type.to_i][1] : 'Move Contract'}"
  end

  def cc_consent(account, logo, tel)
    html = render :template => 'pdf_documents/cc_consent.html.erb', :layout => false,
    :locals => {account: account, logo: logo, tel: tel}
    kit = PDFKit.new(html, :page_size => 'Letter')
    kit.stylesheets << Rails.root + 'public/stylesheets/pdf.css'
    kit.to_pdf
  end

  def non_disclosure(move_id, account, logo, tel, blank)
    move = MoveRecord.find_by_id(move_id)
    html = render :template => 'pdf_documents/non_disclosure.html.erb', :layout => false,
                  :locals => {move: move, account: account, logo: logo, tel: tel, blank: blank}
    kit = PDFKit.new(html, :page_size => 'Letter')
    kit.stylesheets << Rails.root + 'public/stylesheets/pdf.css'
    kit.to_pdf
  end

  def damage_claim
    html = render :template => 'pdf_documents/damage_claim.html.erb', :layout => false
    kit = PDFKit.new(html, :page_size => 'Letter')
    kit.stylesheets << Rails.root + 'public/stylesheets/pdf.css'
    kit.to_pdf
  end

  def terms(move_id)
    move = MoveRecord.find_by_id(move_id)
    html = render :template => 'pdf_documents/terms.html.erb', :layout => false, :locals => {:move => move}
    kit = PDFKit.new(html, :page_size => 'Letter')
    kit.stylesheets << Rails.root + 'public/stylesheets/pdf.css'
    kit.to_pdf
  end

  def costs_and_surchage(move_id)
    move = MoveRecord.find_by_id(move_id)
    html = render :template => 'pdf_documents/costs_and_surchage.html.erb', :layout => false, :locals => {:move => move}
    kit = PDFKit.new(html, :page_size => 'Letter')
    kit.stylesheets << Rails.root + 'public/stylesheets/pdf.css'
    kit.to_pdf
  end

  def cargo(move_id)
    move = MoveRecord.find_by_id(move_id)
    html = render :template => 'pdf_documents/cargo.html.erb', :layout => false, :locals => {:move => move}
    kit = PDFKit.new(html, :page_size => 'Letter')
    kit.stylesheets << Rails.root + 'public/stylesheets/pdf.css'
    kit.to_pdf
  end

  def move(move, document_type)
    margin_top = "0.25in"
    if document_type == Pdf::PROPOSAL
      margin_top = "0.10in"
    end
    html = render :template => 'pdf_documents/move.html.erb', :layout => false, :locals => {:move => move, :document_type => document_type.to_i, :move_type => move.move_type_id}
    kit = PDFKit.new(html, :page_size => 'Letter', :margin_top => margin_top)
    kit.stylesheets << Rails.root + 'public/stylesheets/pdf.css'
    kit.to_pdf
  end
end