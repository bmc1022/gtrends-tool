# frozen_string_literal: true

module CaptureStdout
  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = tmp_stdout = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout # Restore original stdout.
    end
    tmp_stdout.string
  end
end
