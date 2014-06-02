module InventoriesHelper
  def preview_dataset_class(dataset)
    unless dataset.valid?
      "danger"
    end
  end

  def current_inventory
    @current_inventory ||= current_user.inventories.unpublished.first
  end

  def current_catalog
    @current_catalog ||= current_user.inventories.published.first
  end

  def datasets_to_display(datasets)
    if datasets.present?
      datasets
    elsif current_inventory.present?
      current_inventory.datasets
    end
  end

  def invalid_datasets?(inventory)
    inventory.datasets.present? && !inventory.csv_structure_valid?
  end

  def file_structure_feedback(datasets)
    invalid_datasets_count = datasets.map(&:valid?).count(false)
    valid_datasets_count = datasets.map(&:valid?).count(true)
    valid_resources = datasets.map { |dataset| dataset.distributions_count if dataset.valid? }.compact.sum
    invalid_resources = datasets.map { |dataset| dataset.distributions_count unless dataset.valid? }.compact.sum
    "#{valid_datasets_count} conjuntos de datos completos con #{valid_resources} recursos y #{invalid_datasets_count} conjuntos de datos incompletos con #{invalid_resources} recursos."
  end

  def display_publish_form?(from_dashboard)
    unless from_dashboard
      "hidden"
    end
  end

  def inventory_history(inventory)
    "Fecha de captura: #{I18n.l(inventory.created_at, :format => :short)}, por #{inventory.author}."
  end
end