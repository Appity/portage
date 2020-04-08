RSpec.describe Portage::Queue, type: :reactor, timeout: 1 do
  it 'can bridge between a Thread and a Reactor-driven Queue' do
    queue = Portage::Queue.new

    expect(queue).to be_kind_of(Portage::Queue)

    signal = Async::Notification.new

    list = [ ]
    count = 10

    Thread.new do
      expect(Async::Task).to_not be_current

      count.times do |i|
        queue.async do
          list << i
        end
      end

      queue.async do
        signal.signal
      end
    end

    signal.wait

    expect(list).to eq((0...count).to_a)
  end
end
