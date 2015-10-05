module Dossier
  class ReportsController < ApplicationController
    include ViewContextWithReportFormatter

    self.responder = Dossier::Responder

    respond_to *Dossier.configuration.formats

    def show
      respond_with(report)
    end

    private

    def report_class
      Dossier::Model.name_to_class(params[:report])
    end

    def report
      @report ||= report_class.new(options_params)
    end

    def options_params
      params[:options].presence || {}
    end
  end
end
