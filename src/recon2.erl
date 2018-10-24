%%%-------------------------------------------------------------------
%%% @author zhaoweiguo
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Oct 2018 2:15 PM
%%%-------------------------------------------------------------------
-module(recon2).
-author("zhaoweiguo").

%% API
-export([pid_port_num/0, mq_len_num/1, pids_max/2]).


-spec pid_port_num() -> {{pids_num, integer()}, {ports_num, integer()}}.
%% 获得所有进程数,端口数
pid_port_num() ->
  Pids = erlang:processes(),
  Ports = erlang:ports(),
  {
    {pids_num, length(Pids)},
    {ports_num, length(Ports)}
  }.

%% 获得所有进程中message_queue_len大于Len的进程个数
mq_len_num(Len) ->
  Pids = erlang:processes(),
  Self = self(),

  Fun = fun(Pid, Num) ->
          {message_queue_len, Num} = erlang:process_info(Pid, message_queue_len),
          if
            Pid =:= Self -> Num;
            Num > Len -> Num + 1;
            true -> Num
          end
        end,
  lists:foldl(Fun, 0, Pids).






%% 获取Attr最大的N个进程对应Attr值之和
%% @todo
-spec pids_max(N, Attr) -> any() when
  N :: non_neg_integer(),
  Attr :: memory | message_queue_len.
pids_max(N, Attr) ->
  Maxs = recon:proc_count(Attr, N),

  Fun = fun({_Pid, Num, _}, Sum) ->
          Sum + Num
        end,
  lists:foldl(Fun, 0, Maxs).






