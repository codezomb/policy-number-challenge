require_relative '../lib/policy_checksum'

describe PolicyChecksum do
  let(:invalid_policy_number) { '111111111' }
  let(:valid_policy_number)   { '490067719' }

  it 'loads' do
    expect(described_class).to be_a Module
  end

  describe '.checksum' do
    it 'returns a checksum value' do
      expect(described_class.checksum(valid_policy_number)).to be(198)
    end
  end

  describe '.valid?' do
    it 'returns false if the number is valid' do
      expect(described_class.valid?(invalid_policy_number)).to be(false)
    end

    it 'returns true if the number is valid' do
      expect(described_class.valid?(valid_policy_number)).to be(true)
    end
  end
end
