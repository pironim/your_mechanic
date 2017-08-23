require "spec_helper"

describe YourMechanic::Schedule do
  it "has a version number" do
    expect(YourMechanic::VERSION).not_to be nil
  end

  subject(:schedule) { described_class.new }

  describe '#initialize' do
    its(:available_intervals) { is_expected.to eq([]) }
  end

  describe '#available_intervals' do
    let(:add) { [] }
    let(:remove) { [] }

    subject { schedule.available_intervals }

    before do
      add.each { |p| schedule.add(*p) }
      remove.each { |p| schedule.remove(*p) }
    end

    context "when value is added as is to empty schedule" do
      let(:add) { [[1, 5]] }

      it { is_expected.to eq([[1, 5]]) }
    end

    context 'when schedule is extended to the left' do
      let(:add) { [[3, 5], [9, 10], [1, 9]] }

      it { is_expected.to eq([[1, 10]]) }
    end

    context 'when schedule is extended to the right' do
      let(:add) { [[3, 5], [9, 10], [3, 19]] }

      it { is_expected.to eq([[3, 19]]) }
    end

    context 'when schedule is extended to the right and left' do
      let(:add) { [[3, 4], [7, 8], [1, 17]] }

      it { is_expected.to eq([[1, 17]]) }
    end

    context 'when there is no overlaps' do
      let(:add) { [[1, 2], [3, 5], [6, 8]] }

      it { is_expected.to eq([[1, 2], [3, 5], [6, 8]]) }
    end

    context 'join intervals on additions' do
      context 'if overlaped' do
        let(:add) { [[1, 2], [3, 4], [7, 8], [2, 7]] }

        it { is_expected.to eq([[1, 8]]) }
      end

      context "join overlaped intervals" do
        let(:add) { [[1, 2], [3, 4], [7, 8], [2, 4]] }

        it { is_expected.to eq([[1, 4], [7, 8]]) }
      end

      context "replace several intervals with bigger" do
        let(:add) { [[1, 2], [3, 4], [7, 8], [2, 5]] }

        it { is_expected.to eq([[1, 5], [7, 8]]) }
      end

      context "if borders match" do
        let(:add) { [[1, 2], [3, 4], [7, 8], [1, 8]] }

        it { is_expected.to eq([[1, 8]]) }
      end
    end

    context 'raise error for incorrect input' do
      it "for incorrect range" do
        expect{schedule.add(8,1)}.to raise_error(RuntimeError)
      end

      it "for incorrect left border " do
        expect{schedule.add(-1,1)}.to raise_error(RuntimeError)
      end

      it "for incorrect right border " do
        expect{schedule.add(1,99999)}.to raise_error(RuntimeError)
      end

      it "for incorrect left and right" do
        expect{schedule.add(-1,99999)}.to raise_error(RuntimeError)
      end
    end

    context 'remove' do
      let(:add) { [[1, 5]] }
      let(:remove) { [[1, 5]] }

      it { is_expected.to eq([]) }
    end

    context "exact match if any" do
      let(:add) { [[1, 5], [6, 7]] }
      let(:remove) { [[6, 7]] }

      it { is_expected.to eq([[1, 5]]) }
    end

    context 'remove correctly for bigger range' do
      let(:add) { [[1, 5]] }
      let(:remove) { [[9, 10]] }

      it { is_expected.to eq([[1, 5]]) }
    end

    context 'remove partially covered range' do
      let(:add) { [[1, 5]] }
      let(:remove) { [[4, 10]] }

      it { is_expected.to eq([[1, 4]]) }
    end

    context 'split range for subset' do
      let(:add) { [[1, 5]] }
      let(:remove) { [[2, 3]] }

      it { is_expected.to eq([[1, 2], [3, 5]]) }
    end

    context 'cut from several items' do
      let(:add) { [[1, 2], [3, 5], [6, 8]] }
      let(:remove) { [[4, 7]] }

      it { is_expected.to eq([[1, 2], [3, 4], [7, 8]]) }
    end

    context 'change schedule correctly' do
      let(:add) { [[3, 5], [6, 8]] }

      context 'clean schedule for wider range' do
        let(:remove) { [[1, 9]] }

        it { is_expected.to eq([]) }
      end

      context 'clean schedule for same range' do
        let(:remove) { [[3, 8]] }

        it { is_expected.to eq([]) }
      end
    end

    context 'raise error for incorrect input' do
      it "for incorrect range" do
        expect{schedule.remove(8,1)}.to raise_error(RuntimeError)
      end

      it "for incorrect left border " do
        expect{schedule.remove(-1,1)}.to raise_error(RuntimeError)
      end

      it "for incorrect right border " do
        expect{schedule.remove(1,99999)}.to raise_error(RuntimeError)
      end

      it "for incorrect left and right" do
        expect{schedule.remove(-1,99999)}.to raise_error(RuntimeError)
      end
    end
  end
end
