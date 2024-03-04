require './lib/policy_checksum'
require './lib/policy_parser'

class PolicyOcr
  NUMBER_KEYS = PolicyParser.parse(<<~EOT).map.with_index.to_h
     _     _  _     _  _  _  _  _ 
    | |  | _| _||_||_ |_   ||_||_|
    |_|  ||_  _|  | _||_|  ||_| _|
                                  
  EOT

  def initialize(file)
    @lines = File.readlines(file).each_slice(4)
  end

  def details
    @details ||= @lines.map do |line|
      number = PolicyParser.parse(line.join).map { |key| NUMBER_KEYS[key] || '?' }.join
      { status: ill?(number) || err?(number) || 'OK', number: number, key: line }
    end
  end

  def save(file)
    File.open(file, 'w') do |f|
      details.each do |policy|
        f.puts(policy.values_at(:number, :status).join(' '))
      end
    end
  end

  private

  def err?(number)
    return 'ERR' unless PolicyChecksum.valid?(number)
  end

  def ill?(number)
    return 'ILL' if number.include?('?')
  end
end
