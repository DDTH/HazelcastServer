package com.github.ddth.hazelcastserver.qnd;

import java.util.Random;

import com.hazelcast.client.HazelcastClient;
import com.hazelcast.client.config.ClientConfig;
import com.hazelcast.core.HazelcastInstance;
import com.hazelcast.core.IMap;

public class QndTestBigMap {

    public static void main(String[] args) {
        ClientConfig clientConfig = new ClientConfig();
        clientConfig.getGroupConfig().setName("HazelcastServer").setPassword("h2z3lc2st");
        clientConfig.getNetworkConfig().addAddress("localhost:8700");
        HazelcastInstance client = HazelcastClient.newHazelcastClient(clientConfig);
        try {
            Random rand = new Random(System.currentTimeMillis());
            IMap<String, Object> map = client.getMap("demo");
            String str = "";
            for (int i = 0; i < 10000; i++) {
                System.out.println(i);
                str += rand.nextLong();
                String key = String.valueOf(rand.nextLong());
                map.put(key, str);
                // if (!map.tryPut(key, str, 1000, TimeUnit.MILLISECONDS)) {
                // System.out.println("Can not put data to map!");
                // break;
                // }
            }
        } finally {
            client.shutdown();
        }
    }
}
