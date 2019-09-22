# frozen_string_literal: true

describe Guard::SlimLint do
  subject { described_class.new(options) }
  let(:options) { { all_on_start: true, cli: nil } }

  describe '#initialize' do
    context 'when default initialized' do
      it { expect(subject.options[:all_on_start]).to eq true }
      it { expect(subject.options[:cli]).to eq nil }

      context 'when app/views directory exists' do
        before do
          allow(File).to receive(:exist?).with('app/views').and_return(true)
        end

        it { expect(subject.options[:slim_dires]).to eq ['app/views'] }
      end

      context 'when app/views directory not exists' do
        before do
          allow(File).to receive(:exist?).with('app/views').and_return(false)
        end

        it { expect(subject.options[:slim_dires]).to eq ['.'] }
      end
    end
  end

  describe '#start' do
    context 'when :all_on_start option is enabled' do
      let(:options) { { all_on_start: true } }

      it 'call #run' do
        expect(subject).to receive(:run)
        subject.start
      end
    end

    context 'when :all_on_start option is disabled' do
      let(:options) { { all_on_start: false } }

      it 'does nothing' do
        expect(subject).not_to receive(:run)
        subject.start
      end
    end

    context 'when more than one :cli option is specified' do
      let(:options) { { cli: '--color -x RuboCop', slim_dires: ['spec/views/test.slim'] } }

      it 'not raise error' do
        expect { subject.start }.to_not raise_error
      end
    end

    context 'when correct value is specified for the :cli option' do
      let(:options) { { cli: '-x RuboCop', slim_dires: ['spec/views/test.slim'] } }

      it 'not raise error' do
        expect { subject.start }.to_not raise_error
      end
    end

    context 'when abnormal value is specified for the :cli option' do
      let(:options) { { cli: '--error-option' } }

      it 'raise UncaughtThrowError' do
        expect { subject.start }.to raise_error(UncaughtThrowError, /task_has_failed/)
      end
    end

    context 'when abnormal value is specified for the :cli option' do
      let(:options) { { cli: ['--exclude-linter LineLength'] } }

      it 'raise Guard::SlimLint::ArgumentError' do
        expect { subject.start }.to raise_error(ArgumentError, 'Please specify only String for :cli option')
      end
    end
  end

  describe '#reload' do
    it { expect(subject.reload).to eq nil }
  end

  describe '#run_all' do
    it 'call #run' do
      expect(subject).to receive(:run)
      subject.run_all
    end
  end

  describe '#run_on_additions' do
    it 'call #run' do
      expect(subject).to receive(:run).with(['spec/views/sample.html.slim'])
      subject.run_on_additions(['spec/views/sample.html.slim'])
    end
  end

  describe '#run_on_modifications' do
    it 'call #run' do
      expect(subject).to receive(:run).with(['spec/views/sample.html.slim'])
      subject.run_on_modifications(['spec/views/sample.html.slim'])
    end
  end

  describe '#run_on_removals' do
    it { expect(subject.run_on_removals(['spec/views/sample.html.slim'])).to eq nil }
  end
end
