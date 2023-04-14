#!/usr/bin/env escript
%% -*- erlang -*-
%%! -sname test -setcookie test


run(Node, Fun) ->
    case erpc:call(Node, Fun) of
        {ok, Result} ->
            io:format("~p\n", [Result]);
        {error, Error} ->
            io:format("Error when running test case on ~p error: ~p\n", [Node, Error]),
            erlang:halt(1)
    end.

connect_node(Hostname) ->
    true = net_kernel:connect_node(Hostname),
    ok = global:sync().

main([Node]) ->
    NodeStr = list_to_atom(Node),
    connect_node(NodeStr),


    io:format("ok: local node works~n"),
    ok = run(node(), t(node())),

    io:format("ok: remote node works (anonymous Fun)~n"),
    ok = run(NodeStr, t(NodeStr)),

    io:format("error: remote node does not work ~n"),
    % To get this work you need to add
    % -export([t/0]).
    % -mode(compile).
    % 
    % That is fine
    ok = run(NodeStr, fun t/0),

    ok.

t() ->
    io:format("remote node ~p~n", [node()]),
    {ok, []}.
    
t(Node) ->
    fun() -> io:format("from ~p to ~p~n", [Node, node()]), {ok, []} end.
    