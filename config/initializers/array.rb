class Array
  def incremented_sums
    total = 0
    collect {|value| total += value }
  end
end