defmodule GCMSenderTest do
  use ExUnit.Case, async: true
  alias NotificationWorker.Provider.GCMSender

  test "the truth" do
    {:ok, gcm} = GCMSender.start_link([apikey: "AIzaSyBblgLAZHvvhM6gk3ZWcl7-mYQiuStsB40"])

    payload = %{
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
    }

    push_tokens = [
      "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE"
    ]
 
    options = %{
      feedback: %{
        deleted: %{
          method: "POST",
          url: "http://localhost:8080/devices/remove"
                 },
        updated: %{
          method: "POST",
          url: "http://localhost:8080/devices/update"
        }
                }
    }

    assert GCMSender.publish(gcm, %{push_tokens: push_tokens, payload: payload, options: options}) == %{success: 1, failure: 0} 
  end
end
