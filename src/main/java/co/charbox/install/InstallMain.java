package co.charbox.install;

import java.io.IOException;

import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.PostMethod;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import co.charbox.domain.model.auth.DeviceAuthModel;

import com.tpofof.core.App;
import com.tpofof.core.utils.AuthorizationHeader;
import com.tpofof.core.utils.Config;
import com.tpofof.core.utils.HttpClientProvider;
import com.tpofof.core.utils.json.JsonUtils;

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
			config.setProperty("device.api.key", newAuth.getApiKey());
			config.setProperty("install.service.id", "");
			config.setProperty("install.service.apikey", "");
			config.setProperty("install.service.group", "");
		}
	}
	
	protected DeviceAuthModel getNewAuth(String serviceId, String serviceApiKey, String serviceGroup) {
		PostMethod pm = new PostMethod(config.getString("charbot.api.uri", "http://localhost:8080") + "/install");
		pm.addRequestHeader(new AuthorizationHeader(serviceId, serviceApiKey, serviceGroup));
		try {
			if (200 == httpClientProvider.get().executeMethod(pm)) {
				return json.fromJsonResponse(pm.getResponseBodyAsString(), DeviceAuthModel.class);
			}
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			pm.releaseConnection();
		}
		return null;
	}
	
	protected boolean registerDevice(DeviceAuthModel auth) {
		PostMethod pm = new PostMethod(config.getString("charbot.api.uri", "http://localhost:8080") + "/devices/id/" + auth.getDeviceId() + "/register");
		pm.addRequestHeader(new AuthorizationHeader(auth.getDeviceId(), auth.getApiKey()));
		try {
			return 200 == httpClientProvider.get().executeMethod(pm);
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			pm.releaseConnection();
		}
		return false;
	}
	
	public static void main(String[] args) {
		App.getContext().getBean(InstallMain.class).installDeviceCredentials();
	}
}
