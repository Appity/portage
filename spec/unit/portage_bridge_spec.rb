RSpec.describe Portage::Bridge, type: :reactor, timeout: 1 do
  it 'can bridge between a Thread and a Reactor-driven Bridge' do
    bridge = Portage::Bridge.new

    expect(bridge).to be_kind_of(Portage::Bridge)

    signal = Async::Notification.new

    list = [ ]
    count = 1000

    Thread.new do
      expect(Async::Task).to_not be_current

      count.times do |i|
        list << bridge.async do
          i
        end
      end

      bridge.async do
        signal.signal
      end
    end

    signal.wait

    expect(list).to eq((0...count).to_a)
  end
end
