RSpec.describe Portage::ThreadPool, type: :reactor, timeout: 1 do
  class ExampleException < StandardError
  end

  it 'will attach to the default reactor' do
    pool = Portage::ThreadPool.new
  
    pool.wait
  end

  it 'can return the result of the operation' do
    pool = Portage::ThreadPool.new
    thread = Thread.current

    notification = pool.async do
      :value
    end

    result = notification.wait

    expect(result).to eq(:value)

  ensure
    pool.wait
  end

  it 'can raise exceptions' do
    pool = Portage::ThreadPool.new
    thread = Thread.current

    expect do
      pool.async do
        raise ExampleException
      end.wait
    end.to raise_exception(ExampleException)

  ensure
    pool.wait
  end

  it 'can execute without waiting' do
    pool = Portage::ThreadPool.new
    executed = false

    pool.exec do
      executed = true
    end

    sleep(0.001)

    expect(executed).to be(true)

  ensure
    pool.wait
  end

  it 'can perform simple notifications in a separate thread' do
    pool = Portage::ThreadPool.new
    thread = Thread.current

    notification = pool.async do
      Thread.current != thread and :return_value
    end

    result = notification.wait

    expect(result).to eq(:return_value)

  ensure
    pool.wait
  end

  it 'can perform a number notifications in quick succession' do
    pool = Portage::ThreadPool.new
    thread = Thread.current
    count = 1000

    notifications = count.times.map do |i|
      pool.async do
        Thread.current != thread and i
      end
    end

    expect(notifications.map(&:wait)).to eq((0...count).to_a)

  ensure
    pool.wait
  end

  it 'can perform several blocking notifications simultaneously' do
    pool = Portage::ThreadPool.new(size: 25)
    count = 25

    notifications = count.times.map do |i|
      pool.async do
        sleep(0.2)
        i
      end
    end

    expect(notifications.map(&:wait)).to eq((0...count).to_a)

  ensure
    pool.wait
  end
end
