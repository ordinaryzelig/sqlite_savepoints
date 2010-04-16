require 'test_helper'

class SqliteSavepointTest < ActiveSupport::TestCase
  
  def setup
    setup_db
  end
  
  def teardown
    teardown_db
  end
  
  def test_rollback
    sand_boxed do
      ExampleModel.create!
    end
    assert_number_of_example_models 0
  end
  
  def test_commit
    transaction do
      ExampleModel.create!
    end
    assert_number_of_example_models 1
  end
  
  def test_nested_rollback
    sand_boxed do
      ExampleModel.create!
      assert_number_of_example_models 1
      sand_boxed do
        ExampleModel.create!
        assert_number_of_example_models 2
        sand_boxed do
          ExampleModel.create!
          assert_number_of_example_models 3
        end
        assert_number_of_example_models 2
      end
      assert_number_of_example_models 1
    end
    assert_number_of_example_models 0
  end
  
  def test_nested_commit
    transaction do
      ExampleModel.create!
      transaction do
        ExampleModel.create!
      end
    end
    assert_number_of_example_models 2
  end
  
  def test_nested_commits_and_rollbacks
    transaction do
      ExampleModel.create!
      assert_number_of_example_models 1
      sand_boxed do
        ExampleModel.create!
        assert_number_of_example_models 2
        transaction do
          ExampleModel.create!
          assert_number_of_example_models 3
          sand_boxed do
            ExampleModel.create!
            assert_number_of_example_models 4
          end
          assert_number_of_example_models 3
        end
        assert_number_of_example_models 3
      end
      assert_number_of_example_models 1
    end
    assert_number_of_example_models 1
  end
  
  # ==============================
  # assertions.
  
  def assert_number_of_example_models(num)
    assert_equal num, ExampleModel.all.size
  end
  
  # ==============================
  # helpers.
  
  def transaction
    ExampleModel.transaction(:requires_new => true) do
      yield
    end
  end
  
  def sand_boxed
    transaction do
      yield
      raise ActiveRecord::Rollback
    end
  end
  
end
