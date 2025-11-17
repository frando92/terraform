#!/bin/bash

. .env
eval $(ssh-agent)
ssh-add ~/.ssh/tf_ssh