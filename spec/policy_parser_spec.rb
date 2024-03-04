require_relative '../lib/policy_parser'

describe PolicyParser do
  let(:policy_number) do
    <<~EOT
        _  _  _  _  _  _     _ 
    |_||_|| || ||_   |  |  ||_ 
      | _||_||_||_|  |  |  | _|
    EOT
  end
  
  describe '.parse' do
    it 'creates a 3xN array from the string input' do
      expect(described_class.parse(policy_number))
        .to match_array([
          ["   ", "|_|", "  |"], # 4
          [" _ ", "|_|", " _|"], # 9
          [" _ ", "| |", "|_|"], # 0
          [" _ ", "| |", "|_|"], # 0
          [" _ ", "|_ ", "|_|"], # 6
          [" _ ", "  |", "  |"], # 7
          [" _ ", "  |", "  |"], # 7
          ["   ", "  |", "  |"], # 1
          [" _ ", "|_ ", " _|"]  # 5
        ])
    end
  end
end
