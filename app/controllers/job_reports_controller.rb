class JobReportsController < ApplicationController

  before_action :require_job_owner

  def show
    if job_report.error
      render :error
    elsif job_report.results
      render_success
    else
      render :in_progress
    end

  end

  def render_success
    results.flash&.each do |k,v|
      flash[k] = v
    end
    if results.redirect_to
      redirect_to results.redirect_to
    else
      render :success
    end
  end

  def job_report
    @job_report ||= JobReport.find(params[:id])
  end
  helper_method :job_report

  def results
    @results ||= safe_hash(job_report.results)
  end
  helper_method :results

  def error
    @error ||= safe_hash(job_report.error)
  end
  helper_method :error

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
