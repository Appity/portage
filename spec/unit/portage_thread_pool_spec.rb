RSpec.describe Portage::ThreadPool, type: :reactor, timeout: 1 do
  it 'will attach to the default reactor' do
    pool = Portage::ThreadPool.new
  
    pool.wait
  end

  it 'can be attached to a specific reactor' do
    pool = Portage::ThreadPool.new(reactor: reactor)
  
    pool.wait
  end

  it 'can perform simple tasks in a separate thread' do
    pool = Portage::ThreadPool.new
    thread = Thread.current

    task = pool.task do |task|
      Thread.current != thread and :return_value
    end

    result = task.wait

    expect(result).to eq(:return_value)

  ensure
    pool.wait
  end

  it 'can perform a number tasks in quick succession' do
    pool = Portage::ThreadPool.new
    thread = Thread.current
    count = 1000

    tasks = count.times.map do |i|
      pool.task do
        Thread.current != thread and i
      end
    end

    expect(tasks.map(&:wait)).to eq((0...count).to_a)

  ensure
    pool.wait
  end

  it 'can perform several blocking tasks simultaneously' do
    pool = Portage::ThreadPool.new(size: 25)
    count = 25

    tasks = count.times.map do |i|
      pool.task do
        sleep(0.2)
        i
      end
    end

    expect(tasks.map(&:wait)).to eq((0...count).to_a)

  ensure
    pool.wait
  end
end
