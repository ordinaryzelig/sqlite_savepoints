# copied from ActiveRecord::ConnectionAdapters::SQLite3Adapter.

class ActiveRecord::ConnectionAdapters::SQLite3Adapter
  
  def create_savepoint
    execute("SAVEPOINT #{current_savepoint_name}")
  end
  
  def release_savepoint
    execute("RELEASE SAVEPOINT #{current_savepoint_name}")
  end
  
  def rollback_to_savepoint
    execute("ROLLBACK TO SAVEPOINT #{current_savepoint_name}")
  end
  
  def supports_savepoints?
    true
  end
  
end
