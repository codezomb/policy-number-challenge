require_relative '../lib/policy_ocr'

describe PolicyOcr do
  let(:sample_file) { 'spec/fixtures/sample.txt' }
  let(:output_file) { '/tmp/output.txt' }
  let(:subject)     { described_class.new(sample_file) }

  describe '#details' do
    it 'returns an array of hashes for each entry' do
      expect(subject.details.class).to be(Array)
      expect(subject.details.count).to eq(11)
      expect(subject.details[0].class)
        .to be(Hash)
    end

    context 'status' do
      it 'returns ILL' do
        expect(subject.details[10][:status]).to eq('ILL')
      end

      it 'returns ERR' do
        expect(subject.details[1][:status]).to eq('ERR')
      end

      it 'returns OK' do
        expect(subject.details[0][:status]).to eq('OK')
      end
    end

    context 'number' do
      it 'returns the number represented' do
          expect(subject.details[0][:number])
            .to eq("000000000")
      end
    end

    context 'key' do
      it 'returns the original key' do
        expect(subject.details[0][:key].join)
          .to eq <<~EOT
             _  _  _  _  _  _  _  _  _ 
            | || || || || || || || || |
            |_||_||_||_||_||_||_||_||_|
                                       
          EOT
      end
    end
  end

  describe '#save' do
    before { subject.save(output_file) }
    after { `rm #{output_file}` }

    it 'writes a number and status per line' do
      expect(File.readlines(output_file).length)
        .to eq(subject.details.length)
    end

    it 'writes to the given file' do
      expect(File.exist?(output_file))
        .to be(true)
    end
  end
end
