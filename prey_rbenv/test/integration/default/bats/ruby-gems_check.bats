#!/usr/bin/env baats

@test "Is rbenv installed?" {
    run su - vagrant -c 'which rbenv'
    [ "$status" -eq 0 ]
}

@test "Is foreman installed?" {
    run su - vagrant -c 'which foreman'
    [ "$status" -eq 0 ]
}

@test "Do we have bundler?" {
    run su - vagrant -c 'which bundler'
    [ "$status" -eq 0 ]
}
