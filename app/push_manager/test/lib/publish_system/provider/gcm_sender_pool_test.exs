defmodule GcmSenderPoolTest do
  use ExUnit.Case, async: true

  alias PushManager.PublishSystem.Provider.GcmSenderPool
  alias PushManager.PublishSystem.Provider.GcmSender
  
  alias PushManager.PublishSystem.Feedback.FeedbackSender

  setup do
    options = %{
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

    payload =  %{
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
    }


    deviceTokens = ["csDE8A7tpVg:APA91bHZPydo79Po4zEgYsizzottady0lTAikSh-fCLl2twjqLvBjsB8ShEUSpG7QI-IhSTl7or_--yz_oqaWzYfcrWNd4TxHj6Ur6LL0Of2tiXhUepzR_8RaphZomNRsmtTdYKENOm1", "ehxaZbLbQ_I:APA91bFQEl53nDIDTZmMqtaqkAaHiVrsWhD_ex_CgYaqKHVH5l4gSKQdz5K36al6i8N7krSgilmLCX8HcPwQIflSbWet5l1P6ZR68frjWwEpQFYPIVDTi4HyQMdZzYgrnm60kZB6YbFd", "fTLebeOpR-Y:APA91bG3c1Zb5BpjeSXlXXW2ZdYqGLkpX4e13x9l0domnrqKhL6bm-dMpYlUEY1U_urCCJ1HTSXP7gOVtSPsXOZZZiWyZM5GfCRCvQRdlbJhrL-OjgoIC9B2-lSCREQcKWcFZkIAuhQu", "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE", "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE", "cZNfsMGrxfE:APA91bE9a3pkS40bOWDNJq5lp1iJsfN_ENzzVhcjomdFsV3U3CAziqCACH2qda2ZFsBkZktsjGnRXa7n4FsV754n5uQCXN4mqzvRuZcb61QrSO8sDrxW4NkL9OFAtNHyyyZEQ4cy9JyE"]
    {:ok, options: options, payload: payload, deviceTokens: deviceTokens}
  end

  test "gcm pool start" do
    {:ok, pid} = GcmSenderPool.start_link

    assert is_pid(pid)
  end

  test "check out/in worker" do
    {:ok, pid} = GcmSenderPool.start_link
    worker = :poolboy.checkout GcmSender
    :poolboy.checkin GcmSender, worker

    assert is_pid(worker)
  end

  test "PushProvider init test", %{options: options, payload: payload, deviceTokens: deviceTokens} do
    FeedbackSender.start_link
    {:ok, pid} = GcmSenderPool.start_link
    :poolboy.transaction(GcmSender, fn(worker) ->
      GcmSender.publish(worker, {options, payload, deviceTokens})
    end)
  end

end
