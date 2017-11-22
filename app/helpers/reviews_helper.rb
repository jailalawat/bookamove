module ReviewsHelper

  def get_tel_by_move(move, account)
    if move.move_record_location_origin.first.location.calendar_truck_group
      move.move_record_location_origin.first.location.calendar_truck_group.phone_number
    else
      account.office_phone
    end
  end

  def review_links_by_city(city)
    links = {}

    if city == "Calgary"
      links[:google] = "https://www.google.ca/search?site=&source=hp&q=oo+movers+calgary&oq=oo+movers+calgary&gs_l=hp.3..0i13k1l2j38.2512.5381.0.6065.19.19.0.0.0.0.211.1715.12j5j1.18.0....0...1c.1.64.hp..1.17.1597.0..0j0i131k1j0i131i46k1j46i131k1j0i10k1j0i30k1j0i10i30k1j0i22i30k1.XLv60MTbCVw#q=oomovers+calgary&lrd=0x53716f8c1acea6dd:0x13e8a8efdcf21946,3,"
      links[:facebook] = "https://www.facebook.com/pg/OOmoversCalgary/reviews/?ref=page_internal"
      links[:yelp] = "https://www.yelp.ca/writeareview/biz/2y1EaVvUweT-383zt54hDQ?return_url=%2Fbiz%2F2y1EaVvUweT-383zt54hDQ"
      links[:bbb] = "https://www.bbb.org/mbc/business-reviews/movers/owner-operator-movers-of-canada-in-vancouver-bc-111216/reviews-and-complaints/?review=true"
    elsif city == "Edmonton"
      links[:google] = "https://www.google.ca/search?site=&source=hp&q=oo+movers+edmonton&oq=oo+movers+edmonton&gs_l=hp.3..0i13k1l2j38.2512.5381.0.6065.19.19.0.0.0.0.211.1715.12j5j1.18.0....0...1c.1.64.hp..1.17.1597.0..0j0i131k1j0i131i46k1j46i131k1j0i10k1j0i30k1j0i10i30k1j0i22i30k1.XLv60MTbCVw#lrd=0x53a02247edef5945:0x790d9bd60ad16e40,3,"
      links[:facebook] = "https://www.facebook.com/pg/OO-movers-Edmonton-110433919002540/reviews/?ref=page_internal"
      links[:yelp] = "https://www.yelp.ca/writeareview/biz/2VEHOksiYElMxtWukAZgyw?return_url=%2Fbiz%2F2VEHOksiYElMxtWukAZgyw"
      links[:bbb] = "https://www.bbb.org/mbc/business-reviews/movers/owner-operator-movers-of-canada-in-vancouver-bc-111216/reviews-and-complaints/?review=true"
    else
      links[:google] = "https://www.google.ca/search?site=&source=hp&q=oomovers+vancouver&oq=oomovers+vancouver&gs_l=hp.3..0i13k1l2j38.2512.5381.0.6065.19.19.0.0.0.0.211.1715.12j5j1.18.0....0...1c.1.64.hp..1.17.1597.0..0j0i131k1j0i131i46k1j46i131k1j0i10k1j0i30k1j0i10i30k1j0i22i30k1.XLv60MTbCVw#lrd=0x54863a73367c7121:0xe5199ff301080740,3,"
      links[:facebook] = "https://www.facebook.com/pg/OOmoversVancouver/reviews/?ref=page_internal"
      links[:yelp] = "https://www.yelp.ca/writeareview/biz/eCcWzv9jZeWF-4bCv_aYXg?return_url=%2Fbiz%2FeCcWzv9jZeWF-4bCv_aYXg"
      links[:bbb] = "https://www.bbb.org/mbc/business-reviews/movers/owner-operator-movers-of-canada-in-vancouver-bc-111216/reviews-and-complaints/?review=true"
    end

    return links

  end

end
