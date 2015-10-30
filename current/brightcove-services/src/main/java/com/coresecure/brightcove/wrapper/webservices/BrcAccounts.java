/*
    Adobe CQ5 Brightcove Connector

    Copyright (C) 2015 Coresecure Inc.

        Authors:    Alessandro Bonfatti
                    Yan Kisen

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.coresecure.brightcove.wrapper.webservices;

import com.coresecure.brightcove.wrapper.sling.ConfigurationGrabber;
import com.coresecure.brightcove.wrapper.sling.ConfigurationService;
import com.coresecure.brightcove.wrapper.sling.ServiceUtil;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.jackrabbit.api.security.user.Authorizable;
import org.apache.jackrabbit.api.security.user.Group;
import org.apache.jackrabbit.api.security.user.UserManager;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.commons.json.JSONArray;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;

import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Service
@Component
@Properties(value = {
        @Property(name = "sling.servlet.extensions", value = {"json"}),
        @Property(name = "sling.servlet.paths", value = "/bin/brightcove/accounts")
})
public class BrcAccounts extends SlingAllMethodsServlet {

    @Override
    protected void doPost(final SlingHttpServletRequest request,
                          final SlingHttpServletResponse response) throws ServletException,
            IOException {

        api(request, response);


    }


    public void api(final SlingHttpServletRequest request,
                    final SlingHttpServletResponse response) throws ServletException,
            IOException {
        PrintWriter outWriter = response.getWriter();
        response.setContentType("application/json");
        JSONObject root = new JSONObject();
        boolean is_authorized = false;
        try {
            Session session = request.getResourceResolver().adaptTo(Session.class);
            UserManager userManager = request.getResourceResolver().adaptTo(UserManager.class);
                /* to get the current user */
            Authorizable auth = userManager.getAuthorizable(session.getUserID());
            if (auth != null) {
                List<String> memberOf = new ArrayList<String>();
                Iterator<Group> groups = auth.memberOf();
                while (groups.hasNext() && !is_authorized) {
                    Group group = groups.next();
                    memberOf.add(group.getID());
                }
                ConfigurationGrabber cg = ServiceUtil.getConfigurationGrabber();
                JSONArray accounts = new JSONArray();
                int i = 0;
                for (String account : cg.getAvailableServices()) {
                    ConfigurationService cs = cg.getConfigurationService(account);
                    List<String> allowedGroups = new ArrayList<String>();
                    allowedGroups.addAll(cs.getAllowedGroupsList());
                    allowedGroups.retainAll(memberOf);
                    String alias = cs.getAccountAlias();
                    alias = (alias == null) ? account : alias;
                    if (allowedGroups.size() > 0) {
                        JSONObject accountJson = new JSONObject();
                        accountJson.put("text", alias);
                        accountJson.put("value", account);
                        accountJson.put("id", i);
                        i++;
                        accounts.put(accountJson);
                    }
                }
                root.put("accounts", accounts);

            }
            outWriter.write(root.toString(1));
        } catch (JSONException je) {
            outWriter.write("{\"accounts\":[],\"error\":\"" + je.getMessage() + "\"}");
        } catch (RepositoryException e) {
            outWriter.write("{\"accounts\":[],\"error\":\"" + e.getMessage() + "\"}");
        }

    }


    @Override
    protected void doGet(final SlingHttpServletRequest request,
                         final SlingHttpServletResponse response) throws ServletException,
            IOException {
        api(request, response);

    }

}
