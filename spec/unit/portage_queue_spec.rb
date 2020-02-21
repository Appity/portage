RSpec.describe Portage::Queue, type: :reactor, timeout: 1 do
  it 'can bridge between a Thread and a Reactor-driven Queue' do
    queue_in, queue_out = Portage::Queue.pair

    expect(queue_in).to be_kind_of(Portage::Queue::Injector)
    expect(queue_out).to be_kind_of(Async::Queue)

    count = 10

    Thread.new do
      count.times do |i|
        queue_in << i
      end

      queue_in << nil
    end

    sleep(0.01)

    dequeued = [ ]
    queue_out.each do |i|
      dequeued << i
    end

    expect(dequeued).to eq((0...count).to_a)
  end
end
