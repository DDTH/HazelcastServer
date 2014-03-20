package com.github.ddth.hazelcastserver.bootstrap;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.github.ddth.hazelcastserver.internal.MyOutOfMemoryHandler;
import com.hazelcast.config.Config;
import com.hazelcast.config.FileSystemXmlConfig;
import com.hazelcast.config.UrlXmlConfig;
import com.hazelcast.core.Hazelcast;
import com.hazelcast.core.HazelcastInstance;

public class StandaloneBootstrap {

    private static Logger LOGGER;
    static {
        String confHomeDir = System.getProperty("hazelcastserver.home");
        if (confHomeDir == null) {
            System.setProperty("hazelcastserver.home", ".");
        }

        LOGGER = LoggerFactory.getLogger(StandaloneBootstrap.class);
    }

    @SuppressWarnings("unused")
    public static void main(String[] args) throws Exception {
        Config config = loadConfig();
        Hazelcast.setOutOfMemoryHandler(new MyOutOfMemoryHandler());
        HazelcastInstance instance = Hazelcast.newHazelcastInstance(config);
    }

    private static Config loadConfig() throws IOException {
        String configFilename = System.getProperty("configFile");
        if (configFilename != null) {
            File configFile = new File(configFilename);
            LOGGER.info("Loading configurations from file [" + configFile.getAbsolutePath() + "].");
            return new FileSystemXmlConfig(configFile);
        }

        URL urlConfigFile = StandaloneBootstrap.class.getClassLoader().getResource("hazelcast.xml");
        if (urlConfigFile != null) {
            LOGGER.info("Loading configurations from file [" + urlConfigFile.getFile() + "].");
            return new UrlXmlConfig(urlConfigFile);
        }

        LOGGER.warn("No configuration file found! Use default.");
        return new Config();
    }
}
