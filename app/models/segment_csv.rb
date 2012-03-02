require 'csv'

class SegmentCsv < ActiveRecord::Base
  def generate_csv
    interval_vals = Hash.new
    last_max = 0.0
    last_min = 0.0
    last_max_time = 0.0
    max_minus_min = Hash.new # the hash that will be output to a csv
    return "FUCK ALL, THERE DOES NOT APPEAR TO BE AN INPUT CSV" if self.input_csv.nil?
    first = true
    last_row_charge = nil
    low_interval = true
    CSV.parse(self.input_csv, {:headers => :first_row, :col_sep => "\t"}) do |row|
      time = row["Time"].to_s
      this_row_charge = row["Charge"].to_f
      if first
        interval_vals[time] = this_row_charge
        last_row_charge = this_row_charge
        first = false
        next
      end
      if (this_row_charge - last_row_charge).abs >= self.epsilon
        puts interval_vals
        if low_interval
          low_interval = false
          first = true
          last_min = interval_vals.values.min
        else
          low_interval = true
          first = true
          last_max = interval_vals.values.max
          max_minus_min[interval_vals.key(interval_vals.values.max)] = last_max - last_min
        end
        interval_vals.each do |key, value|
          interval_vals.delete(key)
        end
        interval_vals[time] = this_row_charge
      else
        interval_vals[time] = this_row_charge
      end
    end
    csv = "\"Time At Max\",\"(max - min)\"\n"
    max_minus_min.each do |time, max_minus_min|
      csv << "\"" + time.to_s + "\",\"" + max_minus_min.to_s + "\"\n"
    end
    self.csv = csv
    self.save
    return "YEAH THAT TOOK ME ALL OF HALF A SECOND BECAUSE I AM A COMPUTER AND I AM AWESOME."
  end

end
