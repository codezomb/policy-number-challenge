module PolicyChecksum
  VALID_LENGTH = 9

  def self.checksum(number)
    number.reverse.chars.each.with_index(1).sum { |c, i| c.to_i * i }
  end

  def self.valid?(number)
    number.length == VALID_LENGTH && checksum(number) % 11 == 0
  end
end
