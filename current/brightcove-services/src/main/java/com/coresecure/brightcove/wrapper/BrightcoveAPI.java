package com.coresecure.brightcove.wrapper;

import com.coresecure.brightcove.wrapper.api.Cms;
import com.coresecure.brightcove.wrapper.objects.Account;
import com.coresecure.brightcove.wrapper.objects.Platform;
import com.coresecure.brightcove.wrapper.sling.ConfigurationGrabber;
import com.coresecure.brightcove.wrapper.sling.ConfigurationService;
import com.coresecure.brightcove.wrapper.sling.ServiceUtil;

public class BrightcoveAPI {
    public Platform platform;
    public Account account;
    public Cms cms;

    public BrightcoveAPI(String aClient_id, String aClient_secret, String aAccount_id) {
        platform = new Platform();
        account = new Account(platform, aClient_id, aClient_secret, aAccount_id);
        cms = new Cms(account);
    }

    public BrightcoveAPI(String key) {
        platform = new Platform();
        ConfigurationGrabber cg = ServiceUtil.getConfigurationGrabber();
        ConfigurationService brcService = cg.getConfigurationService(key);
        account = new Account(platform, brcService.getClientID(), brcService.getClientSecret(), brcService.getAccountID());
        cms = new Cms(account);
    }
}
