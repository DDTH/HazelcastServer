#!/bin/sh

java -server -Djava.net.preferIPv4Stack=true -cp ../lib/hazelcast-2.6.jar com.hazelcast.examples.TestApp

