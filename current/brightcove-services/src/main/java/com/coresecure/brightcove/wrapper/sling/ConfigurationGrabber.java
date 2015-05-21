package com.coresecure.brightcove.wrapper.sling;

import org.apache.sling.api.SlingHttpServletRequest;

import java.util.Set;

public interface ConfigurationGrabber {
    public ConfigurationService getConfigurationService(String key);
    public Set<String> getAvailableServices();
    public Set<String> getAvailableServices(SlingHttpServletRequest request);
}

