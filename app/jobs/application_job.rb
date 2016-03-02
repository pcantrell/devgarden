class ApplicationJob < ActiveJob::Base
  around_perform do |job, block|
    job_report = job.arguments.first[:job_report]
    return block.call unless job_report

    begin
      job_report.results = block.call
    rescue => e
      job_report.error = {
        message: e.message,
        backtrace: e.backtrace
      }
    ensure
      job_report.completed_at = Time.now
      job_report.save!
    end

  end
end
