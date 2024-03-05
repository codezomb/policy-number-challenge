require './lib/policy_parser'

class PolicyOcr
  # Reference values for what we can expect to find in our files
  NUMBER_KEYS = PolicyParser.parse(<<~EOT).map.with_index.to_h
     _     _  _     _  _  _  _  _ 
    | |  | _| _||_||_ |_   ||_||_|
    |_|  ||_  _|  | _||_|  ||_| _|
                                  
  EOT

  POLICY_LENGTH = 9     # Policy number allowed length
  STATUS_AMB    = 'AMB' # More than 1 possible number
  STATUS_ERR    = 'ERR' # Number is not valid
  STATUS_ILL    = 'ILL' # Number is illegible
  STATUS_OK     = 'OK'  # Number is valid

  def initialize(file)
    @lines = File.readlines(file).each_slice(4)
  end

  def output(with_permutations: true)
    @output ||= @lines.map do |line|
      number = (string = PolicyParser.parse(line.join)).map { |key| NUMBER_KEYS[key] || '?' }.join
      { status: status(number), number: number, string: string, permutations: [] }.tap do |row|
        break row unless with_permutations && row[:status] != STATUS_OK
        break row unless permutations(row) && row[:permutations].any?

        # Update the status of the row now that we have permutations
        row[:status] = status(row[:permutations])

        # Only update the number if we have one permutation
        break row unless row[:permutations].one?
        row[:number] = row[:permutations].first
      end
    end
  end

  def save(file)
    File.open(file, 'w') do |f|
      output.each do |policy|
        f.puts(policy.values_at(:number, :status).join(' '))
      end
    end
  end

  private

  def permutations(row)
    row[:string].each.with_index do |string , pos|
      NUMBER_KEYS.keys.each do |key|
        next unless string.join.chars.zip(key.join.chars).one? { |l, r| l != r }

        row[:number].dup.tap do |num|
          num[pos] = NUMBER_KEYS[key].to_s
          next if status(num) != STATUS_OK
          row[:permutations] << num
        end
      end
    end
  end

  def checksum(number)
    number.reverse.chars.each.with_index(1).sum { |c, i| c.to_i * i }
  end

  def valid?(number)
    number =~ /\d{#{POLICY_LENGTH}}/ && checksum(number) % 11 == 0
  end

  def status(number)
    return STATUS_AMB if number.kind_of?(Array) && number.length > 1
    number = number.first if number.kind_of?(Array)

    return STATUS_ILL if number.include?('?')
    return STATUS_OK  if valid?(number)
    STATUS_ERR
  end
end
