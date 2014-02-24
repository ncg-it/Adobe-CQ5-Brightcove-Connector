<%
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
%>
<%@ page contentType="text/html"
             pageEncoding="utf-8"
             import="com.day.cq.widget.HtmlLibraryManager,
                     com.day.text.Text,
                     java.util.Iterator,
                     com.day.cq.wcm.api.Page,
                     java.io.IOException,
                     com.day.cq.wcm.foundation.ParagraphSystem,
                     com.day.cq.wcm.foundation.Paragraph,
                     com.day.cq.wcm.api.components.IncludeOptions,
                     java.util.ResourceBundle,
                     com.day.cq.i18n.I18n,
com.brightcove.proserve.mediaapi.webservices.BrcService,
com.brightcove.proserve.mediaapi.webservices.BrcUtils,
org.apache.sling.api.resource.*,
org.apache.sling.commons.json.JSONArray,
org.apache.sling.commons.json.JSONException,
org.apache.sling.commons.json.JSONObject" %>
<%@ page import="com.day.cq.wcm.api.NameConstants" %>
<%@include file="/libs/foundation/global.jsp"%><%
    BrcService brcService = BrcUtils.getSlingSettingService();
	String playersPath = brcService.getPlayersLoc();
//out.write(playersPath);
Resource res = resourceResolver.resolve(playersPath);
JSONObject root = new JSONObject();
JSONArray items = new JSONArray();
Iterator<Resource>  playersItr = res.listChildren();
int results = 0;
while (playersItr.hasNext()){
    Page playerRes = playersItr.next().adaptTo(Page.class);

    if (playerRes != null && "brightcove/components/page/brightcoveplayer".equals(playerRes.getContentResource().getResourceType())) {
		JSONObject item = new JSONObject();
		item.put("path", playerRes.getPath());
        item.put("name", playerRes.getTitle());
        results++;
		items.put(item);
    } 
}

root.put("items",items);
root.put("results",results);
out.write(root.toString());
%>
