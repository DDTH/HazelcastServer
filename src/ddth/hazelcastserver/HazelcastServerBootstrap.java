package ddth.hazelcastserver;

import java.io.File;
import java.io.FileNotFoundException;

import com.hazelcast.config.Config;
import com.hazelcast.config.FileSystemXmlConfig;
import com.hazelcast.core.Hazelcast;
import com.hazelcast.core.HazelcastInstance;

public class HazelcastServerBootstrap {

	@SuppressWarnings("unused")
	public static void main(String[] args) throws FileNotFoundException {
		File configFile = new File(System.getProperty("configFile"));
		if (!configFile.isFile() || !configFile.canRead()) {
			errorExit(configFile.getAbsolutePath() + " not readable!");
		}
		Config config = new FileSystemXmlConfig(configFile);
		HazelcastInstance instance = Hazelcast.newHazelcastInstance(config);
	}

	public static void errorExit(String msg) {
		System.err.println("Error: " + msg);
		System.exit(-1);
	}
}
