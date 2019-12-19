#!/bin/bash

echo '请输入需要WyhShowEmpty.podspec需要push的spec名称'

read spec

pod repo push $spec WyhShowEmpty.podspec --allow-warnings --verbose --use-libraries
pod repo update $spec
