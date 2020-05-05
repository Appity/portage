RSpec.describe Portage::ThreadTask, type: :reactor do
  class CustomException < StandardError
  end

  context 'can wrap a Thread as if it were an Async::Task' do
    it 'given a block to execute' do
      parent_thread = Thread.current

      result = Portage::ThreadTask.async do
        Thread.current != parent_thread
      end.wait

      expect(result).to be(true)
    end

    it 'given a block that raises an exception' do
      task = Portage::ThreadTask.async do
        raise CustomException, 'test'
      end

      expect { task.wait }.to raise_exception(CustomException)
    end

    it 'given a block and an annotation' do
      task = Portage::ThreadTask.async(annotate: 'example_task') do
        :example
      end

      expect(task.annotation).to eq('example_task')
      expect(task.wait).to be(:example)
    end
  end
end