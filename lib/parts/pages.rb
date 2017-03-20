module Part
  module Page
    def spot_subject(page)
      subject = Hash.new

      r1 = Regexp.new('/#{class_conf[cs_catalog_slug]}/(\\d+)-\\w+')
      r2 = Regexp.new('/#{class_conf[p_catalog_slug]}/(\\d+)-\\w+')

      r3 = Regexp.new('/blogs/post/\\w+') # /blogs/post/novoe-muzhskoe-belie-dlya-teh-kto-lyubit-pogoryachee
      r4 = Regexp.new('/buy/variations/(\\d+)') # /buy/variations/320
      r5 = Regexp.new('/products/variations/(\\d+)-(\\d+)') # /products/variations/479420-320

      if page =~ r1
        subject[:type] = "pt_skkt"
        subject[:id] =  page.split('/')[2].split('-')[0].to_i
      elseif page =~ r2
        subject[:type] = "pt_pkt"
        subject[:id] = page.split('/')[2].split('-')[0].to_i
      elseif page =~ r3
        subject[:type] = "pt_pkbp" # define subject_id in incomming hash
      elseif page =~ r4
        subject[:type] = "pt_plt"
        subject[:id] = page.split('/')[3].to_i # multigroup id
      elseif page =~ r5
        subject[:type] = "pt_plt"
        subject[:id] = page.split('/')[3].split('-')[1].to_i # multigroup id
      end
      return subject
    end

    def create_page_stat(switcher, hash={})
      subject = spot_subject(hash[:page])
      subject[:type] = hash[:subject_type].nil? ? subject[:type] : hash[:subject_type]
      subject[:id] = hash[:subject_id].nil? ? subject[:id] : hash[:subject_id]
      subject.each { |key, value| hash[key] = value }

      case switcher
        when 'Month'
          PagesByMonth.create(company_id: hash[:company_id],
                                date: hash[:beginning_of_month],
                                page: hash[:page],
                                pages: hash[:pages],
                                subject_type: hash[:type],
                                subject_id: hash[:id])
        when 'Week'
          PagesByWeek.create(company_id: hash[:company_id],
                              first_week_day: hash[:first_week_day],
                              last_week_day: hash[:last_week_day],
                              year: hash[:year],
                              week: hash[:week],
                              page: hash[:page],
                              pages: hash[:pages],
                              subject_type: hash[:type],
                              subject_id: hash[:id])
      end
    end

    def update_page_stat(switcher, id, hash={})
      case switcher
      when 'Month'
        pages = PagesByMonth.select("pages").where(id: id).first.pages
        puts 'Pages: ' + pages.to_s
        v = pages.to_i + hash[:pages]
        PagesByMonth.update(id, pages: v)
      when 'Week'
        pages = PagesByWeek.select("pages").where(id: id).first.pages
        puts 'Pages: ' + pages.to_s
        v = pages.to_i + hash[:pages]
        PagesByWeek.update(id, pages: v)
      end
    end
  end
end
