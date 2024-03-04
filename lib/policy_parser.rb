module PolicyParser
  def self.parse(number)
    grouping = number.split("\n").first.length / 3
    number.scan(/.{3}/).each_slice(grouping)
      .to_a.transpose
  end
end
