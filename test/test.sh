#!/bin/sh
set -euf
top=$(git rev-parse --show-toplevel)

setup() {
    tmp="$top/test/tmp"
    rm -rf "$tmp"
    mkdir "$tmp"
    cp "$top/gitignore" "$tmp/.gitignore"
    cd "$tmp"
    git init --quiet
}

assert() {
    git add --all
    dir="$top/test/results/$1"
    mkdir -p "$dir/git_check_ignore"
    mkdir -p "$dir/git_status"
    git status --ignored > "$dir/git_status/actual.txt"
    find . -not -path './.git/*' -a -not -path './.git' -a -not -path './.gitignore' |
        cut -d/ -f2- |
        git check-ignore -v --stdin |
        sed 's/^.gitignore:[0-9]*://' |
        sort > "$dir/git_check_ignore/actual.txt"
    diff "$dir/git_status/actual.txt" "$dir/git_status/expect.txt"
    diff "$dir/git_check_ignore/actual.txt" "$dir/git_check_ignore/expect.txt"
}

test_gitignore_rules() {
    setup
    mkdir dir
    for x in \
        gitignore \
        foo_gitignore \
        foo.gitignore \
        foo-gitignore
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
    done
    assert "test_gitignore_rules"
}

test_dot_rules() {
    setup
    mkdir dir
    for x in \
        foo \
        foo_bar \
        foo.bar \
        foo-bar
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
    done
    assert "test_dot_rules"
}

test_keep_rules() {
    setup
    mkdir dir
    for x in \
        keep \
        foo_keep \
        foo-keep \
        foo.keep
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
    done
    assert "test_keep_rules"
}

test_env_rules() {
    setup
    mkdir dir
    mkdir subdir
    for x in \
        env \
        env_example \
        env-example \
        env.example \
        env_foo \
        env-foo \
        env.foo
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
        mkdir "subdir/$x"
        touch "subdir/$x/foo"
    done
    assert "test_env_rules"
}

test_encryption_rules() {
    setup
    mkdir dir
    for x in \
        foo.aes \
        foo.age \
        foo.argon2 \
        foo.bcrypt \
        foo.gpg \
        foo.pgp \
        foo.scrypt
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
    done
    assert "test_encryption_rules"
}

test_example_rules() {
    setup
    mkdir dir
    mkdir subdir
    for x in \
        example \
        example.foo \
        example-foo \
        example_foo \
        foo.example \
        foo-example \
        foo_example \
        foo.example.goo \
        foo-example-goo \
        foo_example_goo \
        examples \
        examples.foo \
        examples-foo \
        examples_foo \
        foo.examples \
        foo-examples \
        foo_examples \
        foo.examples.goo \
        foo-examples-goo \
        foo_examples_goo
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
        mkdir "subdir/$x"
        touch "subdir/$x/foo"
    done
    assert "test_example_rules"
}

test_backup_rules() {
    setup
    mkdir dir
    mkdir subdir
    for x in \
        backup  \
        backup.foo  \
        backup-foo  \
        backup_foo  \
        foo.backup \
        foo-backup \
        foo_backup \
        backups \
        backups.foo \
        backups-foo \
        backups_foo \
        foo.backups \
        foo-backups \
        foo_backups
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
        mkdir "subdir/$x"
        touch "subdir/$x/foo"
    done
    assert "test_backup_rules"
}

test_tmp_rules() {
    setup
    mkdir dir
    mkdir subdir
    for x in \
        tmp \
        tmp.foo  \
        tmp-foo  \
        tmp_foo  \
        foo.tmp \
        foo-tmp \
        foo_tmp \
        temp \
        temp.foo \
        temp-foo \
        temp_foo \
        foo.temp \
        foo-temp \
        foo_temp
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
        mkdir "subdir/$x"
        touch "subdir/$x/foo"
    done
    assert "test_tmp_rules"
}

test_log_rules() {
    setup
    mkdir dir
    mkdir subdir
    for x in \
        log \
        log.foo \
        log-foo \
        log_foo \
        foo.log \
        foo-log \
        foo_log \
        logs \
        logs.foo \
        logs-foo \
        logs_foo \
        foo.logs \
        foo-logs \
        foo_logs
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
        mkdir "subdir/$x"
        touch "subdir/$x/foo"
    done
    assert "test_log_rules"
}

test_cache_rules() {
    setup
    mkdir dir
    mkdir subdir
    for x in \
        cache \
        cache.foo \
        cache-foo \
        cache_foo \
        foo.cache \
        foo-cache \
        foo_cache \
        caches \
        caches.foo \
        caches-foo \
        caches_foo \
        foo.caches \
        foo-caches \
        foo_caches
    do
        touch ".$x"
        touch "$x"
        touch "dir/.$x"
        touch "dir/$x"
        mkdir "subdir/$x"
        touch "subdir/$x/foo"
    done
    assert "test_cache_rules"
}

test_gitignore_rules
test_dot_rules
test_keep_rules
test_env_rules
test_encryption_rules
test_example_rules
test_backup_rules
test_tmp_rules
test_log_rules
test_cache_rules
