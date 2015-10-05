module Dossier
  module ViewContextWithReportFormatter
    def view_context
      super.tap { |vc| vc.extend(report.formatter) if action_name == 'show' }
    end
  end
end
