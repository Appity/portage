RSpec.describe Portage::ThreadPool, type: :reactor, timeout: 1 do
  class ExampleException < StandardError
  end

  it 'will attach to the default reactor' do
    pool = Portage::ThreadPool.new
  
    pool.wait
  end

  it 'can be attached to a specific reactor' do
    pool = Portage::ThreadPool.new(reactor: reactor)
  
    pool.wait
  end

  it 'can return the result of the operation' do
    pool = Portage::ThreadPool.new
    thread = Thread.current

    task = pool.task do |task|
      :value
    end

    result = task.wait

    expect(result).to eq(:value)

  ensure
    pool.wait
  end

  it 'can raise exceptions' do
    pool = Portage::ThreadPool.new
    thread = Thread.current

    task = pool.task(annotate: 'raise') do |task|
      raise ExampleException
    end

    expect { task.wait }.to raise_exception(ExampleException)

  ensure
    pool.wait
  end

  it 'can annotate the wrapper task' do
    pool = Portage::ThreadPool.new
    task_captured = nil

    task = pool.task(annotate: 'example') do |t|
      task_captured = t
      :value
    end

    expect(task.annotation).to eq('example')

    result = task.wait

    expect(task_captured).to be(task)
    expect(result).to eq(:value)

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
