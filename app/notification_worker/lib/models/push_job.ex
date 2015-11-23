defmodule NotificationWorker.PushJob do
  defstruct pushId: "", page: 0, itemPerPage: 0, condition: nil, sendCount: 0, payload: nil, deviceTokens: [], timezone: "", publishTime: 0
end
