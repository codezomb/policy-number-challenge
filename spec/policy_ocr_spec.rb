require_relative '../lib/policy_ocr'

describe PolicyOcr do
  let(:invalid_policy_number) { '111111111' }
  let(:valid_policy_number)   { '490067719' }
  let(:sample_file)           { 'spec/fixtures/sample.txt' }
  let(:output_file)           { '/tmp/output.txt' }
  let(:subject)               { PolicyOcr.new(sample_file) }

  describe '#output' do
    it 'returns an array of hashes, one hash for each policy number' do
      expect(subject.output.class).to be(Array)
      expect(subject.output.count).to eq(12)
      expect(subject.output[0].class)
        .to be(Hash)
    end

    context 'status' do
      it "returns #{PolicyOcr::STATUS_AMB} when multiple permutations exist" do
        expect(subject.output[9][:status]).to eq(PolicyOcr::STATUS_AMB)
      end

      it "returns #{PolicyOcr::STATUS_ILL} when unable to match a number" do
        expect(subject.output[11][:status])
          .to eq(PolicyOcr::STATUS_ILL)
      end

      it "returns #{PolicyOcr::STATUS_ERR} when unable to validate" do
        expect(subject.output[2][:status])
          .to eq(PolicyOcr::STATUS_ERR)
      end

      it "returns #{PolicyOcr::STATUS_OK} when validated" do
        expect(subject.output[0][:status])
          .to eq(PolicyOcr::STATUS_OK)
      end
    end

    context 'number' do
      it 'returns a permutation when it cannot read' do
        expect(subject.output[10][:number])
            .to eq("123456789")
      end

      it 'returns the number represented' do
          expect(subject.output[0][:number])
            .to eq("000000000")
      end
    end
  end

  describe '#save' do
    before { subject.save(output_file) }
    after { `rm #{output_file}` }

    it 'writes a number and status per line' do
      expect(File.readlines(output_file).length)
        .to eq(subject.output.length)
    end

    it 'writes to the given file' do
      expect(File.exist?(output_file))
        .to be(true)
    end
  end
end
