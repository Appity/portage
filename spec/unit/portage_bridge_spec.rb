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
        list << bridge.async do |task|
          task.sleep(0.000001)
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

  it 'will bridge into the same reactor' do
    bridge = Portage::Bridge.new
    signal = Async::Notification.new

    Thread.new do
      bridge.async do |task|
        expect(task.reactor.object_id).to eq(reactor.object_id)
        signal.signal
      end
    end

    signal.wait
  end
end
