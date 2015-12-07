defmodule Util.Parser do
  def decimal_to_integer(decimal) do
    decimal
    |> Decimal.to_string
    |> Integer.parse
    |> elem(0)
  end

  def timestamp_to_long({mega, sec, micro}), do: mega * 1000000 + sec 

  def long_to_timestamp(long), do: {div(long, 1000000), rem(long, 1000000), 0}
  def long_to_ecto_date_time(timestamp) do
    case timestamp |>  long_to_timestamp |> Timex.Date.from(:timestamp) |> Timex.DateFormat.format!("{ISOz}") |> Ecto.DateTime.cast do
      {:ok, date_time} -> date_time
      {:err, _} -> nil
    end
  end

  def timex_to_long(%Timex.DateTime{} = time), do: time |> Timex.Date.to_timestamp |> timestamp_to_long

  def ecto_to_long(%Ecto.DateTime{} = time), do: time |> Ecto.DateTime.to_iso8601 |> iso_to_long
  def ecto_to_long(nil), do: nil

  def iso_to_long(iso), do: iso |> Timex.DateFormat.parse!("{ISOz}") |> timex_to_long
  def iso_to_long(nil), do: nil  
end
