/*
    Adobe CQ5 Brightcove Connector

    Copyright (C) 2011 Coresecure Inc.

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
package com.brightcove.proserve.mediaapi.webservices;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;
import org.apache.sling.commons.json.JSONArray;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;
import org.apache.sling.commons.json.io.JSONWriter;



@Service
@Component
@Property(name = "sling.servlet.paths", value = "/bin/brightcove/suggestions")
public class BrcSuggestions extends SlingAllMethodsServlet {
	
	@Override
	protected void doPost(final SlingHttpServletRequest request,
            final SlingHttpServletResponse response) throws ServletException,
            IOException {
    		PrintWriter outWriter = response.getWriter();
    		response.setContentType("application/json");
    		JSONObject root = new JSONObject();
    		
    		BrcService brcService = BrcUtils.getSlingSettingService();
    		String ReadToken = brcService.getReadToken();
    		String WriteToken = brcService.getWriteToken();
    		
    		int requestedAPI = 0;
    		String requestedToken="";
    		if (request.getParameter("query") != null) {
    		    response.setContentType("application/json");
    		    outWriter.write(BrcUtils.getList(ReadToken,"name,id,thumbnailURL",false,request.getParameter("start"),request.getParameter("limit"),request.getParameter("query")));
    		            	
    		               
    		} else {
    			outWriter.write("{\"items\":[],\"results\":0}");
    		}
    		
			

    }
    @Override
    protected void doGet(final SlingHttpServletRequest request,
            final SlingHttpServletResponse response) throws ServletException,
            IOException {
    		PrintWriter outWriter = response.getWriter();
    		response.setContentType("application/json");
    		JSONObject root = new JSONObject();
    		
    		BrcService brcService = BrcUtils.getSlingSettingService();
    		String ReadToken = brcService.getReadToken();
    		String WriteToken = brcService.getWriteToken();
    		
    		int requestedAPI = 0;
    		String requestedToken="";
    		if (request.getParameter("query") != null) {
    		    response.setContentType("application/json");
    		    if ("playlist".equalsIgnoreCase(request.getParameter("type"))) {
    		    	outWriter.write(BrcUtils.getPlaylistByID(request.getParameter("query"), request.getParameter("start"),request.getParameter("limit")));
    		    } else {
    		    	outWriter.write(BrcUtils.getSuggestions(request.getParameter("query"), request.getParameter("start"),request.getParameter("limit")));	
    		    }
    		    
    		} else {
    			outWriter.write("{\"items\":[],\"results\":0}");
    		}

    }

}
