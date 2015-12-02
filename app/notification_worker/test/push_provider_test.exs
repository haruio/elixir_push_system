defmodule PushProviderTest do
  use ExUnit.Case, async: true

  alias NotificationWorker.Provider.PushProviderSup
  alias NotificationWorker.Provider.PushDispatcher

  setup do
    options = %{
      gcm_options: %{
        api_key: "AIzaSyBblgLAZHvvhM6gk3ZWcl7-mYQiuStsB40",
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
                   },
      apns_options: %{

      },
      service_id: "abc123EFG456"
    }

    notification_job = %{
      serviceId: "abc123EFG456",
      pushId: 1,
      page: 0,
      itemPerPage: 5000,
      isLast: true,
      sendCount: 6,
      payload: %{
        message: %{
          title: "죽창!!!",
          body: "모두 죽창을 들자!!!"
        },
        extra: %{
          smallImage: "http://file.thisisgame.com/upload/tboard/user/2015/07/10/20150710030032_8190p.jpg",
          visible: true,
          bigImage: "http://upload2.inven.co.kr/upload/2015/02/20/bbs/i3119459344.png",
          body: "너도 한방 나도 한방 우리 모두 죽창 한방",
          title: "죽창!!",
          type: "POST",
          url: "dingo://post/yHhXfm"
        }
      },
      deviceTokens:
      [ %{ uuid: "550e8400-e29b-41d4-a716-446655440000",
           pushToken: "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE",
           pushType: "GCM" },
        %{ uuid: "eb93c707-1c93-478e-bd54-975417171771",
           pushToken: "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE",
           pushType: "GCM" },
        %{ uuid: "ffffffff-83f0-9751-94bf-97950033c587",
           pushToken: "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE",
           pushType: "GCM" },
        %{ uuid: "ffffffff-8d91-54dd-ffff-ffff8ad6dd0e",
           pushToken: "fTLebeOpR-Y:APA91bG3c1Zb5BpjeSXlXXW2ZdYqGLkpX4e13x9l0domnrqKhL6bm-dMpYlUEY1U_urCCJ1HTSXP7gOVtSPsXOZZZiWyZM5GfCRCvQRdlbJhrL-OjgoIC9B2-lSCREQcKWcFZkIAuhQu",
           pushType: "GCM" },
        %{ uuid: "ffffffff-972f-0681-78b9-e8ba0033c587",
           pushToken: "ehxaZbLbQ_I:APA91bFQEl53nDIDTZmMqtaqkAaHiVrsWhD_ex_CgYaqKHVH5l4gSKQdz5K36al6i8N7krSgilmLCX8HcPwQIflSbWet5l1P6ZR68frjWwEpQFYPIVDTi4HyQMdZzYgrnm60kZB6YbFd",
           pushType: "GCM" },
        %{ uuid: "ffffffff-d6d3-d689-ffff-ffffde13d6f5",
           pushToken: "csDE8A7tpVg:APA91bHZPydo79Po4zEgYsizzottady0lTAikSh-fCLl2twjqLvBjsB8ShEUSpG7QI-IhSTl7or_--yz_oqaWzYfcrWNd4TxHj6Ur6LL0Of2tiXhUepzR_8RaphZomNRsmtTdYKENOm1",
           pushType: "GCM" } ]
    }

    {:ok, options: options, notification_job: notification_job}
  end

  test "PushProvider init test", %{options: options, notification_job: _} do
    # PushProviderSup.start_link(options)
  end

  test "dispatch notification", %{options: options, notification_job: notification_job} do
    PushProviderSup.start_link(options)
    PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    # PushDispatcher.dispatch notification_job
    :timer.sleep 1000
    assert 1 == 1
  end
end
