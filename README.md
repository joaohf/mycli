# Possible bug when executing fun() erpc

It's possible to send a fun() to be executed into a remote node using eprc and rpc modules.

But I can't make it work sending a erpc call inside an escript program.

Here is my example case:

Build the mycli escript using rebar3 like that:

    rebar3 escriptize

Steps to reproduce:

In a shell, start the prod node:

    erl -sname prod -setcookie test

In another shell, start the mycli as:


    _build/default/bin/mycli migrate -r "prod@$(hostname)"

    ok: local node works
    from 'mycli@CL-B3-00008' to 'mycli@CL-B3-00008'
    []
    error: remote node does not work
    escript: exception error: {exception,undef,
                            [{#Fun<mycli_migrate.0.98502704>,[],[]},
                             {erlang,apply,2,[]}]}
    in function  erpc:call/5 (erpc.erl, line 505)
    in call from mycli_migrate:run/2 (/home/joaohf/tmp/mycli/src/mycli_migrate.erl, line 47)
    in call from mycli_migrate:migrate/1 (/home/joaohf/tmp/mycli/src/mycli_migrate.erl, line 32)
    in call from escript:run/2 (escript.erl, line 750)
    in call from escript:start/1 (escript.erl, line 277)
    in call from init:start_em/1
    in call from init:do_boot/3