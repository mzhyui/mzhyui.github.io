#!/bin/bash

# Wait for python task
pid=1342

while kill -0 $pid 2> /dev/null; do
    # 如果进程仍在运行，等待一段时间
    sleep 1
done

# Execute the swaks command
./swaks --auth \
       --server smtp.mailgun.org \
       --au postmaster@mailgun.mzhyui.com \
       --ap pass_phrase \
       --from "postmaster@mailgun.mzhyui.com" \
       --to "mzhyui@hotmail.com" \
       --h-Subject: "Hello" \
       --body 'finished!' \
       --attach @file.type
