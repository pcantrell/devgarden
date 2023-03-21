module Enumerable
  def frequencies
    inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  end

  def most_frequent_element
    freq = frequencies.max_by(&:last)&.first
  end
end
