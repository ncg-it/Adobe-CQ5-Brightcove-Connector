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
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Properties;
import org.apache.jackrabbit.api.security.user.Authorizable;
import org.apache.jackrabbit.api.security.user.Group;
import org.apache.jackrabbit.api.security.user.UserManager;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;
import org.apache.sling.commons.json.JSONArray;

import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.jcr.Node;

@Service
@Component
@Properties(value = {
		@Property(name = "sling.servlet.extensions", value = { "json" }),
		@Property(name = "sling.servlet.paths", value = "/bin/brightcove/api")
})
public class BrcApi extends SlingAllMethodsServlet {
	
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
		

		int requestedAPI = 0;
		String requestedAccount="";
		if (request.getParameter("a") != null && request.getParameter("account_id") != null && !request.getParameter("account_id").trim().isEmpty()) {
		    response.setContentType("application/json");
            requestedAccount = request.getParameter("account_id");
            ConfigurationGrabber cg = ServiceUtil.getConfigurationGrabber();
            ConfigurationService cs = cg.getConfigurationService(requestedAccount);
            ServiceUtil serviceUtil = new ServiceUtil(requestedAccount);
            boolean is_authorized = false;

            Session session = request.getResourceResolver().adaptTo(Session.class);
            UserManager userManager = request.getResourceResolver().adaptTo(UserManager.class);
                /* to get the current user */
            try {
                Authorizable auth = userManager.getAuthorizable(session.getUserID());

                if (auth != null ) {
                    List<String> allowedGroups = cs.getAllowedGroupsList();
                    Iterator<Group> groups = auth.memberOf();
                    while (groups.hasNext() && !is_authorized) {
                        Group group = groups.next();
                        if (allowedGroups.contains(group.getID())) is_authorized = true;
                    }
                }
            } catch (RepositoryException re) {
            }
            if (is_authorized) {
                requestedAPI = Integer.parseInt(request.getParameter("a"));
                switch (requestedAPI) {
                    case 0: //no commands
                        outWriter.write("Test");
                        break;
                    case 1:
                        JSONObject players = null;
                        String type = request.getParameter("players_type");
                        if ("legacy".equals(type)) {
                            players = new JSONObject();
                            try {
                                JSONArray playesArray = new JSONArray();

                                String playersPath = cs.getPlayersLoc();
                                Resource res = request.getResourceResolver().resolve(playersPath);
                                Iterator<Resource> playersItr = res.listChildren();
                                while (playersItr.hasNext()) {
                                    Resource playerRes = playersItr.next().getChild("jcr:content");
                                    if (playerRes != null) {
                                        Node playerNode = playerRes.adaptTo(Node.class);
                                        if (playerRes != null && "brightcove/components/page/brightcoveplayer".equals(playerRes.getResourceType())) {
                                            try {
                                                org.apache.sling.commons.json.JSONObject item = new JSONObject();
                                                String path = playerRes.getPath();
                                                String title = playerNode.hasProperty("jcr:title") ? playerNode.getProperty("jcr:title").getString() : playerNode.getName();
                                                String account = playerNode.hasProperty("account") ? playerNode.getProperty("account").getString() : playerNode.getName();
                                                if (!account.trim().isEmpty() && account.equals(requestedAccount)) {
                                                    item.put("id", path);
                                                    item.put("name", title);
                                                    playesArray.put(item);
                                                }
                                            } catch (Exception e) {

                                            }
                                        }
                                    }
                                }
                                players.put("items", playesArray);
                                players.put("item_count", playesArray.length());
                            } catch (JSONException e) {
                                //to-do
                            }
                        } else {
                            players = serviceUtil.getPlayers();
                        }


                        outWriter.write(players.toString());
                        break;
                    case 2:
                        if (request.getParameter("query") != null && !request.getParameter("query").trim().isEmpty()) {
                            int start = 0;
                            try {
                                start = Integer.parseInt(request.getParameter("start"));
                            } catch (NumberFormatException e) {
                            }
                            int limit = serviceUtil.DEFAULT_LIMIT;
                            try {
                                limit = Integer.parseInt(request.getParameter("limit"));
                            } catch (NumberFormatException e) {
                            }
                            outWriter.write(serviceUtil.getList(false, start, limit, false, request.getParameter("query")));
                        } else {
                            outWriter.write(serviceUtil.getListSideMenu(request.getParameter("limit")));
                        }
                        break;
                    case 3:
                        response.setHeader("Content-type", "application/xls");
                        response.setHeader("Content-disposition", "inline; filename=Brightcove_Library_Export.csv");
                        outWriter.write(serviceUtil.getList(true, Integer.parseInt(request.getParameter("start")), Integer.parseInt(request.getParameter("limit")), true, request.getParameter("query")));
                        break;
                    case 4:
                        if (request.getParameter("query") != null && !request.getParameter("query").trim().isEmpty()) {
                            outWriter.write(serviceUtil.getPlaylistByID(request.getParameter("query")).toString());
                        } else {
                            outWriter.write(serviceUtil.getListPlaylistsSideMenu(request.getParameter("limit")));
                        }
                        break;
                    case 5:
                        if ("true".equals(request.getParameter("isID"))) {
                            JSONObject items = new JSONObject();
                            JSONArray videos = new JSONArray();
                            try {
                                JSONObject video = serviceUtil.getSelectedVideo(request.getParameter("query"));

                                long totalItems = 0;
                                if (video.has("id")) {
                                    totalItems = 1;
                                    videos.put(video);
                                }
                                items.put("items", (JSONArray) videos);
                                items.put("totals", totalItems);

                                outWriter.write(items.toString(1));
                            } catch (JSONException je) {
                                outWriter.write("{\"items\":[],\"totals\":0}");
                            }
                        } else {
                            outWriter.write(serviceUtil.searchVideo(request.getParameter("query"), Integer.parseInt(request.getParameter("start")), Integer.parseInt(request.getParameter("limit"))));
                        }
                        break;
                    case 6:
                        if ("true".equals(request.getParameter("isID"))) {
                            JSONObject items = new JSONObject();
                            JSONArray playlists = new JSONArray();
                            try {
                                JSONObject playlist = serviceUtil.getPlaylistByID(request.getParameter("query"));

                                long totalItems = 0;
                                if (playlist.has("id")) {
                                    totalItems = 1;
                                    playlists.put(playlist);
                                }
                                items.put("items", (JSONArray) playlists);
                                items.put("totals", totalItems);

                                outWriter.write(items.toString(1));
                            } catch (JSONException je) {
                                outWriter.write("{\"items\":[],\"totals\":0}");
                            }
                        } else {
                            outWriter.write(serviceUtil.getPlaylists(Integer.parseInt(request.getParameter("start")), Integer.parseInt(request.getParameter("limit")), false, false));
                        }
                        break;
                    default:
                        break;
                }
            } else {
                outWriter.write("{\"items\":[],\"totals\":0}");
            }
        } else {
            outWriter.write("{\"items\":[],\"totals\":0}");
        }

    }


    @Override
    protected void doGet(final SlingHttpServletRequest request,
            final SlingHttpServletResponse response) throws ServletException,
            IOException {
    	api(request, response);
    	
    }

}
