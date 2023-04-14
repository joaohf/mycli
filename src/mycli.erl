%% @doc
%% Main entry point for My Command Line Interface tool.
%% @end
-module(mycli).

-export([main/1]).

modules() ->
    % New modules goes here:
    [
        mycli_migrate
    ].

main(Args) ->
    cli:run(Args, #{modules => modules(), progname => "mycli"}).
