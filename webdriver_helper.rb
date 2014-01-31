def getAnyLocator(*locator)

  str_pattern = /ctl[0-9]*_ctl[0-9]*_phContent_ctl[0-9]*_ctl/
  pageSource = @driver.page_source.to_s
  splitToNewline = pageSource.gsub(/\>/, ">\r\n")

  splitToNewline.each_line do |line|
    splitAddID = locator[35, locator.length()]
    lines_matcher = line.include? splitAddID
    if lines_matcher
      each_line_matcher = line.scan(str_pattern)
      if each_line_matcher
        getID_matcher = line.scan(/id="ctl[0-9]*_ctl[0-9]*_phContent_ctl[0-9]*_ctl[a-zA-z0-9]*"/)
      else
        getID_matcher = line.scan(/id="ctl[a-zA-z0-9]*"/)
      end
    end
  end

end
