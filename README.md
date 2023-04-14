# Possible bug when executing fun() erpc

It's possible to send a fun() to be executed into a remote node using eprc and rpc modules.

But I can't make it work sending a erpc call inside an escript program.

Here is my example case:

## First case, using escriptlize

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

## Second example, using pure escript just to check if it works

Pure escript, but no argparse support.

In a shell, start the prod node:

    erl -sname prod -setcookie test

In another shell, start the run the escript as:

    cd script
    ./mycli.escript "test@$(hostname)"
    ok: local node works
    from 'test@CL-B3-00008' to 'test@CL-B3-00008'
    []
    ok: remote node works (anonymous Fun)
    from 'test@CL-B3-00008' to 'test@CL-B3-00008'
    []
    error: remote node does not work
    escript: exception error: undefined function erl_eval:t/0

## Third example, using escript with argparse

escript with `-mode(compile)`.

In a shell, start the prod node:

    erl -sname prod -setcookie test

In another shell, start the run the escript as:

    cd script
    ERL_FLAGS="-pa ../_build/default/lib/argparse/ebin" ./mycli_argparse.script migrate -r "prod@$(hostname)"
    ok: local node works
    from 'test@CL-B3-00008' to 'test@CL-B3-00008'
    []
    error: remote node does not work, anonymous function
    escript: exception error: {exception,undef,
                            [{#Fun<mycli_argparse_script__escript__1681__482311__249278__9.0.50584357>,
                              [],[]},
                             {erlang,apply,2,[]}]}
    in function  erpc:call/5 (erpc.erl, line 505)
    in call from mycli_argparse_script__escript__1681__482311__249278__9:run/2 (./mycli_argparse.script, line 54)
    in call from mycli_argparse_script__escript__1681__482311__249278__9:migrate/1 (./mycli_argparse.script, line 39)
    in call from escript:run/2 (escript.erl, line 750)
    in call from escript:start/1 (escript.erl, line 277)
    in call from init:start_em/1
    in call from init:do_boot/3
