class JobReportsController < ApplicationController

  before_action :require_job_owner

  def show
    respond_to do |format|
      format.json do
        render json: {
          message: job_report_message,
          completed: job_report.completed?
        }
      end

      format.html do
        if job_report.error
          render :error
        elsif job_report.results
          render_success
        else
          render :in_progress
        end
      end
    end
  end

  def render_success
    results.flash&.each do |k,v|
      flash[k] = v
    end
    redirect_to results.redirect_to || root_url
  end

  def job_report
    @job_report ||= JobReport.find(params[:id])
  end
  helper_method :job_report

  def job_report_message
    job_report.message || "Working…"
  end
  helper_method :job_report_message

  def results
    @results ||= safe_hash(job_report.results)
  end
  helper_method :results

  def error
    @error ||= safe_hash(job_report.error)
  end
  helper_method :error

  def spinner_dot_numbers
    dot_count = 12
    1.upto(dot_count * 2 - 1).map do |x|
      (dot_count - x).abs + 1
    end
  end
  helper_method :spinner_dot_numbers

private

  def require_job_owner
    unless current_user.id == job_report.owner_id
      redirect_to login_path, flash: { error: "You must log in as the owner of this job in order to view it." }
    end
  end

  def safe_hash(h)
    OpenStruct.new(h)
  end
end
