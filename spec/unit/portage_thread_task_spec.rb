RSpec.describe Portage::ThreadTask, type: :reactor do
  class CustomException < StandardError
  end

  context 'can wrap a Thread as if it were an Async::Task' do
    it 'given a block to execute' do
      parent_thread = Thread.current

      result = Portage::ThreadTask.new do
        Thread.current != parent_thread
      end.wait

      expect(result).to be(true)
    end

    it 'given a block that raises an exception' do
      task = Portage::ThreadTask.new do
        raise CustomException, 'test'
      end

      expect { task.wait }.to raise_exception(CustomException)
    end
  end
end