class HomeController < ApplicationController
  def index
    @segment_csv = SegmentCsv.first(:conditions => {:session_id => request.session_options[:id]})
    if @segment_csv.nil?
      @segment_csv = SegmentCsv.new
      @segment_csv.session_id = request.session_options[:id]
      @segment_csv.save
    end
  end
end
