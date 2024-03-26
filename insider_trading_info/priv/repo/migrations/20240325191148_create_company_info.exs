defmodule Trading.Repo.Migrations.CreateCompanyMasterInfo do
  use Ecto.Migration

  def change do
    create table(:company_info) do
      add :cik, :integer
      add :previous_years_data_fetched, :boolean, default: false
      add :ticker, :string
      add :company_name, :string
      add :data_availability_date, :date
      timestamps(type: :utc_datetime)
    end
  end
end
