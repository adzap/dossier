module Dossier
  module ApplicationHelper

    def formatted_dossier_report_path(format, report)
      path_params = { report: report.report_name }
      path_params[:format] = format unless format == 'html'
      path_params[:options] = report.options unless report.options.empty?
      dossier_report_path(path_params)
    end

    def render_options(report)
      return if report.parent
      render "#{Dossier.configuration.templates_path}/#{report.report_name}/options", report: report
    rescue ActionView::MissingTemplate
    end

  end
end
