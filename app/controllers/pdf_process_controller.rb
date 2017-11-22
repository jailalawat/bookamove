class PdfProcessController < ApplicationController
  before_filter :current_user

  def terms
    p = Pdf.new
    send_data p.terms(params[:id]),
              :filename => "terms.pdf",
              :type => "application/pdf"
  end

  def cargo
    p = Pdf.new
    send_data p.cargo(params[:id]),
              :filename => "cargo.pdf",
              :type => "application/pdf"
  end

  def cc_consent
    move = MoveRecord.find_by_id(params[:id])
    account = move.account
    if move.move_record_location_origin.first.location.calendar_truck_group
      tel = move.move_record_location_origin.first.location.calendar_truck_group.phone_number
    else
      tel = account.office_phone
    end
    logo = account[:logo].blank? ? "http://oomovers.moversnetwork.ca/images/logo2.png" : "http://oomovers.moversnetwork.ca/uploads/account/#{account[:logo]}"

    p = Pdf.new
    send_data p.cc_consent(account, logo, tel),
              :filename => "cc_consent.pdf",
              :type => "application/pdf"
  end

  def damage_claim
    p = Pdf.new
    send_data p.damage_claim,
              :filename => "damage_claim.pdf",
              :type => "application/pdf"
  end

  def move
    move_record = MoveRecord.find_by_id(params[:id])
    p = Pdf.new
    send_data p.move(move_record, params[:document_type]),
              :filename => Pdf.document_title(move_record, params[:document_type].to_i, true).parameterize('_') + ".pdf",
              :type => "application/pdf"
  end

  def non_disclosure
    move = MoveRecord.find_by_id(params[:id])
    account = move.account
    if move.move_record_location_origin.first.location.calendar_truck_group
      tel = move.move_record_location_origin.first.location.calendar_truck_group.phone_number
    else
      tel = account.office_phone
    end
    logo = account[:logo].blank? ? "http://oomovers.moversnetwork.ca/images/logo2.png" : "http://oomovers.moversnetwork.ca/uploads/account/#{account[:logo]}"

    p = Pdf.new
    send_data p.non_disclosure(params[:id], account, logo, tel, params[:blank]),
              :filename => "settlement_agreement.pdf",
              :type => "application/pdf"
  end

  def costs_and_surchage
    p = Pdf.new
    send_data p.costs_and_surchage(params[:id]),
              :filename => "costs_and_surchage.pdf",
              :type => "application/pdf"
  end
end
