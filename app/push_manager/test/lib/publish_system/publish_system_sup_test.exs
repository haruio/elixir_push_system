defmodule PublishSystemTest do
  use ExUnit.Case, async: true

  alias PushManager.PublishSystem
  alias PushManager.PublishSystem.Provider.PushDispatcher

  setup do
    notification = %{
      serviceId: "service_id",
      payload:  %{
        message: %{
          title: "죽창!!!",
          body: "모두 죽창을 들자!!!"
                 },
        extra: %{
          serviceId: "service_id_123",
          pushId: "push_id_123",
          smallImage: "http://file.thisisgame.com/upload/tboard/user/2015/07/10/20150710030032_8190p.jpg",
          visible: true,
          bigImage: "http://upload2.inven.co.kr/upload/2015/02/20/bbs/i3119459344.png",
          body: "너도 한방 나도 한방 우리 모두 죽창 한방",
          title: "죽창!!",
          type: "POST",
          url: "dingo://post/yHhXfm"
        }
      },
      pushTokens: [
        %{
          pushToken: "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE",
          pushType: "GCM",
          uuid: "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE"
    }],
      options: %{
        gcm: %{ api_key: "AIzaSyBblgLAZHvvhM6gk3ZWcl7-mYQiuStsB40" },
        apns: nil,
        service_id: "abc123EFG456",
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
    }

    {:ok, notification: notification}
  end


  test "start publish system", %{notification: notification} do
    PushDispatcher.dispatch(notification)
  end


end
