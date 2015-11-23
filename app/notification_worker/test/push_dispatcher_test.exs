defmodule PushDispatcherTest do
  use ExUnit.Case, async: true
  alias NotificationWorker.Provider.PushSenderSup
  alias NotificationWorker.Provider.PushDispatcher

  setup do
    {:ok, provider} = PushSenderSup.start_link [service_id: :dingo]
    {:ok, provider: provider}
  end

  test "PushProvider init test", %{provider: provider} do
    notification_job = %{
      service_id: :dingo,
      payload: %{
        message: %{
          pushId: "ididididid",
          title: "타이틀이 1 ",
          shortData: %{
            image: "http://icon.daumcdn.net/w/icon/1312/19/152729032.png",
            description: "짧짧짧"
          },
          bigData: %{
            image: "http://icon.daumcdn.net/w/icon/1312/19/152729032.png",
            description: "긴긴긴"
          },
          type: "POST",
          url: "dingo://post/UKhXfm",
          visible: true
                 }
      },
      push_tokens: [
        %{
          push_token: "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE",
          push_type: "GCM",
          uuid: "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE"
    }
      ]
    }

    PushDispatcher.dispatch(notification_job) == :ok
  end

  test "lookup test" do
    sender = PushDispatcher.lookup(:dingo_gcm)

  end
end
