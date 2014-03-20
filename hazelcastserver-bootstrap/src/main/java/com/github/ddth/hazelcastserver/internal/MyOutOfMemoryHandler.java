package com.github.ddth.hazelcastserver.internal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hazelcast.core.HazelcastInstance;
import com.hazelcast.core.OutOfMemoryHandler;

/**
 * OutOfMemory Handler.
 * 
 * @author Thanh Nguyen <btnguyen2k@gmail.com>
 * @since 3.2-RC2
 */
public class MyOutOfMemoryHandler extends OutOfMemoryHandler {

    private final Logger LOGGER = LoggerFactory.getLogger(MyOutOfMemoryHandler.class);

    /**
     * {@inheritDoc}
     */
    @Override
    public void onOutOfMemory(OutOfMemoryError oome, HazelcastInstance[] instances) {
        // for (HazelcastInstance instance : instances) {
        // if (instance != null) {
        // try {
        // Helper.tryCloseConnections(instance);
        // } catch (Exception e) {
        // LOGGER.warn(e.getMessage(), e);
        // }
        //
        // try {
        // Helper.tryStopThreads(instance);
        // } catch (Exception e) {
        // LOGGER.warn(e.getMessage(), e);
        // }
        //
        // try {
        // Helper.tryShutdown(instance);
        // } catch (Exception e) {
        // LOGGER.warn(e.getMessage(), e);
        // }
        // }
        // }
        LOGGER.error("OOM! Shutting down [" + instances.length + "] instances...");
        LOGGER.error(oome.getMessage(), oome);
        System.exit(-1);
    }

}
