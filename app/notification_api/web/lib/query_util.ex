defmodule NotificationApi.Util.QueryUtil.Paginator do
  defstruct [:pageSize, :firstPageNo, :prevPageNo, :startPageNo, :pageNo, :endPageNo,
             :nextPageNo, :finalPageNo, :totalCount, :data ]
  import Ecto.Query

  def new(query, params \\ %{}) do
    page_number = params |> Dict.get("pageNum", 1) |> to_int |> bigger_then_or(0, 1)
    page_size = params |> Dict.get("pageSize", 10) |> to_int |> bigger_then_or(10, 10)

    data = do_query(query, page_number, page_size)
    total_data_count = count_query(query)

    prevPageNo = if page_number-1 > 0, do: page_number-1, else: 1
    endPageNo = ceiling(total_data_count / page_size)
    nextPageNo = if page_number < endPageNo, do: page_number+1, else: page_number

    %NotificationApi.Util.QueryUtil.Paginator{
      pageSize: page_size,
      firstPageNo: 1,
      prevPageNo: prevPageNo,
      startPageNo: 1,
      pageNo: page_number,
      endPageNo: endPageNo,
      nextPageNo: nextPageNo,
      finalPageNo: endPageNo,
      totalCount: total_data_count,
      data: data
    }
 end

  defp do_query(query, page_number, page_size) do
    offset = page_size * (page_number - 1)
    query
    |> limit([_], ^page_size)
    |> offset([_], ^offset)
    |> NotificationApi.Repo.all
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
                 neg when neg < 0 ->
                   t
                 pos when pos > 0 ->
                   t + 1
                 _ -> t
    end
  end

  defp count_query(query) do
    query
    |> exclude(:order_by)
    |> exclude(:preload)
    |> exclude(:select)
    |> select([e], count(e.service_id))
    |> NotificationApi.Repo.one
  end

  defp to_int(i) when is_integer(i), do: i
  defp to_int(s) when is_binary(s) do
    case Integer.parse(s) do
      {i, _} -> i
      :error -> :error
    end
  end
  defp bigger_then_or(i, t, o), do: if i > t, do: i, else: o 
end
