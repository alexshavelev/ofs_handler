%%------------------------------------------------------------------------------
%% Copyright 2014 FlowForwarding.org
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%-----------------------------------------------------------------------------

%% @author Erlang Solutions Ltd. <openflow@erlang-solutions.com>
%% @copyright 2014 FlowForwarding.org

%%% @doc
%%% ofs_handler_message supervisor.
%%% @end
-module(ofs_handler_message_sup).
-copyright("2013, Erlang Solutions Ltd.").

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).
-export([start_child/5]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    C = ofs_handler_message,
    RestartStrategy = simple_one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
    {ok, {SupFlags,
            [{C, {C, start_link, []}, temporary, 1000, worker, [C]}]}}.

start_child(Connection, AuxId, CallbackMod, CallbackState, Subscriptions) ->
    supervisor:start_child(?MODULE, [Connection, AuxId, CallbackMod, CallbackState, Subscriptions]).
