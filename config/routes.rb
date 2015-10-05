Rails.application.routes.draw do
  get "reports/*report", to: 'dossier/reports#show', as: :dossier_report
end
