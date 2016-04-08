class ApplicationJob < ActiveJob::Base

  around_perform do |job, block|
    @job_report = job.arguments.first[:job_report]

    begin
      results = block.call
      @job_report&.results = results
    rescue => e
      if @job_report
        # If there is a report, user can see error & decode to retry manually
        @job_report.error = {
          message: e.message,
          backtrace: e.backtrace
        }
      else
        # No report, so automatically retry
        raise
      end
    ensure
      @job_report&.completed_at = Time.now
      @job_report&.save!
    end
  end

  def show_message(message)
    logger.info message
    @job_report&.update!(message: message) if @job_report
  end

end
