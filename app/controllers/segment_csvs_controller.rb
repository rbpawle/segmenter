class SegmentCsvsController < ApplicationController
  def update
    if params[:segment_csv]
      model = SegmentCsv.first(:conditions => {:session_id => request.session_options[:id]})
      if model.nil?
        model = SegmentCsv.new
        model.session_id = request.session_options[:id]
      end
      if params[:segment_csv][:csv].nil?
        flash[:notice] = "WITHOUT AN UPLOADED CSV I CANNOT GENERATE MEANINGFUL DATA"
        redirect_to "/"
        return
      end
      model.input_csv = params[:segment_csv][:csv].read
      model.epsilon = params[:segment_csv][:epsilon]
      model.save
      errors = model.generate_csv
      flash[:notice] = errors if errors
    end
    redirect_to "/"
  end
end
