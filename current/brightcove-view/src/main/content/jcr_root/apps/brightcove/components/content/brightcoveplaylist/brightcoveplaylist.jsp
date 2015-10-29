<%--

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

--%>
<%@ page import="com.coresecure.brightcove.wrapper.sling.ConfigurationGrabber,
                 com.coresecure.brightcove.wrapper.sling.ConfigurationService,
                 com.coresecure.brightcove.wrapper.sling.ServiceUtil,
                 com.day.cq.wcm.api.WCMMode,
                 com.day.cq.wcm.api.components.DropTarget,
                 java.util.UUID" %>

<%@include file="/libs/foundation/global.jsp" %>
<%

    String containerClass = DropTarget.CSS_CLASS_PREFIX + "brightcovevideo";


    UUID video_uuid = new UUID(64L, 64L);
    String VideoRandomID = video_uuid.randomUUID().toString().replaceAll("-", "");
    String playerPath = properties.get("playerPath", "");
    String videoPlayerPL = properties.get("videoPlayerPL", "");
    String account = properties.get("account", "");
    String margLeft = "auto";
    String margRight = "auto";
    String position = "center";
    String width = "480";
    String height = "270";

    String playerID = "";
    String playerKey = "";
    if (!account.trim().isEmpty()) {
        ConfigurationGrabber cg = ServiceUtil.getConfigurationGrabber();
        ConfigurationService cs = cg.getConfigurationService(account);
        if (cs != null) {
            playerID = cs.getDefPlaylistPlayerID();
            playerKey = cs.getDefPlaylistPlayerKey();
        }
    }

    boolean hasSize = false;
    boolean editMode = false;
    if (!(WCMMode.fromRequest(request) == WCMMode.DISABLED || WCMMode.fromRequest(request) == WCMMode.PREVIEW))
        editMode = true;

    if (!playerPath.trim().isEmpty()) {
        Page playerPage = resourceResolver.resolve(playerPath).adaptTo(Page.class);
        ValueMap playerProperties = playerPage.getProperties();
        String playerAccount = playerProperties.get("account", account);
        if (account.isEmpty() && playerProperties.containsKey("account")) {
            currentNode.setProperty("account", playerAccount);
            currentNode.save();
        }
        request.setAttribute("account", playerAccount);
        if (playerProperties.containsKey("playerID") && playerProperties.containsKey("playerKey")) {
            playerID = playerProperties.get("playerID", playerID);
            playerKey = playerProperties.get("playerKey", playerKey);
        }
        position = playerProperties.get("align", position);
        if (position.equals("left")) {
            margLeft = "0";
        } else if (position.equals("right")) {
            margRight = "0";
        }
        if (playerProperties.containsKey("width") && playerProperties.containsKey("height")) {

            width = playerProperties.get("width", String.class);
            height = playerProperties.get("height", String.class);
            hasSize = true;
        } else if (playerProperties.containsKey("width") && !playerProperties.containsKey("height")) {
            width = playerProperties.get("width", String.class);
            height = String.valueOf(270 * playerProperties.get("width", 1) / 480);
            hasSize = true;

        } else if (!playerProperties.containsKey("width") && playerProperties.containsKey("height")) {
            height = playerProperties.get("height", String.class);
            width = String.valueOf(480 * playerProperties.get("height", 1) / 270);
            hasSize = true;

        }
        if (!hasSize) {
            request.setAttribute("inlinecss", "true");
%>
<style>
    #container-<%=VideoRandomID %> {
        width: 80%;
        display: block;
        position: relative;
        margin: 20px auto;
    }

    #container-<%=VideoRandomID %>:after {
        padding-top: 56.25%;
        display: block;
        content: '';
    }

    #container-<%=VideoRandomID %> object {
        position: absolute;
        top: 0;
        bottom: 0;
        right: 0;
        left: 0;
        width: 100%;
        height: 100%;
    }

</style>
<%
        }
    }
    if (!account.trim().isEmpty() || !playerPath.trim().isEmpty()) {
%>
<div data-sly-test="${wcmmode.edit}" class="cq-dd-brightcove_player md-dropzone-video" data-sly-text="Drop player here"
     style="margin-bottom: 0;margin-left: <%=margLeft%>;margin-right: <%=margRight%>;margin-top: 0;overflow-x: hidden;overflow-y: hidden;text-align: center;width: 100%;text-align:<%=properties.get("align","center")%>;">

    <div id="container-<%=VideoRandomID %>" class="brightcove-container" style="width:100%">

    </div>


    <cq:includeClientLib js="brc.BrightcoveExperiences-custom"/>
    <script type="text/javascript">


        // listener for media change events
        function onMediaBegin(event) {
            var BCLcurrentVideoID;
            var BCLcurrentVideoNAME;
            BCLcurrentVideoID = BCLvideoPlayer.getCurrentVideo().id;
            BCLcurrentVideoNAME = BCLvideoPlayer.getCurrentVideo().displayName;
            switch (event.type) {
                case "mediaBegin":
                    var currentVideoLength = "0";
                    currentVideoLength = BCLvideoPlayer.getCurrentVideo().length;
                    if (currentVideoLength != "0") currentVideoLength = currentVideoLength / 1000;
                    if (typeof _gaq != "undefined") _gaq.push(['_trackEvent', location.pathname, event.type + " - " + currentVideoLength, BCLcurrentVideoNAME + " - " + BCLcurrentVideoID]);
                    break;
                case "mediaPlay":
                    _gaq.push(['_trackEvent', location.pathname, event.type + " - " + event.position, BCLcurrentVideoNAME + " - " + BCLcurrentVideoID]);
                    break;
                case "mediaStop":
                    _gaq.push(['_trackEvent', location.pathname, event.type + " - " + event.position, BCLcurrentVideoNAME + " - " + BCLcurrentVideoID]);
                    break;
                case "mediaChange":
                    _gaq.push(['_trackEvent', location.pathname, event.type + " - " + event.position, BCLcurrentVideoNAME + " - " + BCLcurrentVideoID]);
                    break;
                case "mediaComplete":
                    _gaq.push(['_trackEvent', location.pathname, event.type + " - " + event.position, BCLcurrentVideoNAME + " - " + BCLcurrentVideoID]);
                    break;
                default:
                    _gaq.push(['_trackEvent', location.pathname, event.type, BCLcurrentVideoNAME + " - " + BCLcurrentVideoID]);
            }
        }

    </script>
    <script>
        customBC.createPlaylist("<%=width%>", "<%=height%>", "<%=playerID%>", "<%=playerKey%>", "<%=videoPlayerPL%>", "container-<%=VideoRandomID %>");
    </script>

    <% if (editMode) { %>
    <div data-sly-test="${wcmmode.edit}"
         class="cq-dd-brightcove_playlist cq-video-placeholder cq-block-sm-placeholder md-dropzone-video"
         data-sly-text="Drop video here" style="width:99%"></div>
    <% } %>
</div>
<% } else { %>
<div data-sly-test="${wcmmode.edit}"
     class="cq-dd-brightcove_player cq-video-placeholder cq-block-sm-placeholder md-dropzone-video"
     data-sly-text="Drop player here"></div>
<% } %>





