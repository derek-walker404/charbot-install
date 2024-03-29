package co.charbox.install;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.httpclient.methods.PostMethod;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import co.charbox.domain.model.auth.DeviceAuthModel;

import com.fasterxml.jackson.databind.JsonNode;
import com.google.common.collect.Maps;
import com.tpofof.core.App;
import com.tpofof.core.utils.AuthorizationHeader;
import com.tpofof.core.utils.Config;
import com.tpofof.core.utils.HttpClientProvider;
import com.tpofof.core.utils.json.JsonUtils;

@Slf4j
@Component
public class InstallMain {

	@Autowired private HttpClientProvider httpClientProvider;
	@Autowired private Config config;
	@Autowired private JsonUtils json;
	
	public void installDeviceCredentials() {
		String serviceId = config.getString("install.service.id");
		String serviceApiKey = config.getString("install.service.apikey");
		String serviceGroup = config.getString("install.service.group");
		DeviceAuthModel newAuth = getNewAuth(serviceId, serviceApiKey, serviceGroup);
		if (newAuth != null && registerDevice(newAuth)) {
			config.setProperty("device.id", newAuth.getDeviceId());
			config.setProperty("device.api.key", newAuth.getKey());
			config.setProperty("install.service.id", "");
			config.setProperty("install.service.apikey", "");
			config.setProperty("install.service.group", "");
			Map<String, String> schedules = getJobSchedules();
			for (Entry<String, String> e : schedules.entrySet()) {
				config.setProperty(e.getKey(), e.getValue());
			}
		}
	}
	
	protected DeviceAuthModel getNewAuth(String serviceId, String serviceApiKey, String serviceGroup) {
		String uri = config.getString("charbot.api.url", "http://localhost:8080") + "/install";
		log.debug("New Auth Url: " + uri);
		PostMethod pm = new PostMethod(uri);
		pm.addRequestHeader(new AuthorizationHeader(serviceId, serviceApiKey, serviceGroup));
		try {
			int status = httpClientProvider.get().executeMethod(pm);
			if (200 == status) {
				return json.fromJsonResponse(pm.getResponseBodyAsString(), DeviceAuthModel.class);
			} else {
				log.error("New Auth Error. Status: " + status);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			pm.releaseConnection();
		}
		return null;
	}
	
	protected boolean registerDevice(DeviceAuthModel auth) {
		PostMethod pm = new PostMethod(config.getString("charbot.api.url", "http://localhost:8080") + "/devices/id/" + auth.getDeviceId() + "/register");
		pm.addRequestHeader(new AuthorizationHeader(auth.getDeviceId(), auth.getKey()));
		try {
			return 200 == httpClientProvider.get().executeMethod(pm);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			pm.releaseConnection();
		}
		return false;
	}
	
	protected Map<String, String> getJobSchedules() {
		Map<String, String> schedules = Maps.newHashMap();
		PostMethod pm = new PostMethod(config.getString("charbot.api.url", "http://localhost:8080") + "/schedules");
		try {
			if (200 == httpClientProvider.get().executeMethod(pm)) {
				JsonNode node = json.toJsonNodeFromResponse(pm.getResponseBodyAsString()).get("data");
				Iterator<Entry<String, JsonNode>> fields = node.fields();
				while (fields.hasNext()) {
					Entry<String, JsonNode> field = fields.next();
					schedules.put(field.getKey(), field.getValue().asText());
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			pm.releaseConnection();
		}
		return schedules;
	}
	
	public static void main(String[] args) {
		App.getContext().getBean(InstallMain.class).installDeviceCredentials();
	}
}
