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
<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="com.day.cq.wcm.api.components.DropTarget,java.util.UUID,com.brightcove.proserve.mediaapi.webservices.*"%>
 <%
 
 String containerClass = DropTarget.CSS_CLASS_PREFIX + "brightcovevideo";



UUID video_uuid = new UUID(64L,64L);
String VideoRandomID = new String(video_uuid.randomUUID().toString().replaceAll("-",""));
%>

<%


    String margLeft = "auto";
    String margRight = "auto";
    String position= "center";
    String width = "480";
    String height = "270";
    boolean hasSize = false;

    BrcService brcService = BrcUtils.getSlingSettingService();
    String playerID = brcService.getDefPlaylistPlayerID();
    String playerKey = brcService.getDefPlaylistPlayerKey();
    if (currentNode.hasProperty("playerSelector")) {
        String playerSelector = properties.get("playerSelector", "");
        Resource playerRes = resourceResolver.resolve(playerSelector);
        if (playerRes!= null && playerRes.adaptTo(Page.class) != null) {
            Page playerPage = playerRes.adaptTo(Page.class);
            ValueMap playerProperties = playerPage.getProperties();
            if (playerProperties.containsKey("playerID") && playerProperties.containsKey("playerKey")){
                playerID =playerProperties.get("playerID",playerID);
                playerKey =playerProperties.get("playerKey",playerKey);
            }
            position= playerProperties.get("align",position);
            if (position.equals("left")) {
                margLeft ="0";
            } else if (position.equals("right")) {
                margRight = "0";
            }
            if (playerProperties.containsKey("width") && playerProperties.containsKey("height")) {

                width = playerProperties.get("width", String.class);
                height = playerProperties.get("height", String.class);
                hasSize = true;
            } else if (playerProperties.containsKey("width") && !playerProperties.containsKey("height")) {
                width = playerProperties.get("width", String.class) ;
                height =String.valueOf(270 * playerProperties.get("width", 1) / 480);
                hasSize = true;

            } else if (!playerProperties.containsKey("width") && playerProperties.containsKey("height")) {
                height = playerProperties.get("height", String.class) ;
                width  =String.valueOf(480 * playerProperties.get("height", 1) / 270);
                hasSize = true;

            } 
        }

    }
    //todo move it on the page head tag
if (!hasSize ) { //&& request.getAttribute("inlinecss") == null) {
%>
<style>
    #<%=VideoRandomID %>.brightcove-container {
            position:relative;
            height: 0;
            padding-bottom: 56.25%;
            padding-top: 1px;
        }
    #<%=VideoRandomID %>.brightcove-container div, #<%=VideoRandomID %>.brightcove-container embed, #<%=VideoRandomID %>.brightcove-container object, #<%=VideoRandomID %>.BrightcoveExperience {
        height: 100%;
        left: 0;
        position: absolute;
        top: 0;
        width: 100%;
    }
</style>
<%
    request.setAttribute("inlinecss", "true");
}
%>
<div style="margin-bottom: 0;margin-left: <%=margLeft%>;margin-right: <%=margRight%>;margin-top: 0;overflow-x: hidden;overflow-y: hidden;text-align: center;width: 100%;text-align:<%=properties.get("align","center")%>;">
    <div id="<%=VideoRandomID %>"  class="brightcove-container" style="width:100%">

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
                    var currentVideoLength ="0";
                    currentVideoLength = BCLvideoPlayer.getCurrentVideo().length;
                    if (currentVideoLength != "0") currentVideoLength = currentVideoLength/1000;
                    if (typeof _gaq != "undefined") _gaq.push(['_trackEvent', location.pathname, event.type+" - "+currentVideoLength, BCLcurrentVideoNAME+" - "+BCLcurrentVideoID]);
                    break;
                case "mediaPlay":
                    _gaq.push(['_trackEvent', location.pathname, event.type+" - "+event.position, BCLcurrentVideoNAME+" - "+BCLcurrentVideoID]);
                    break;
                case "mediaStop":
                    _gaq.push(['_trackEvent', location.pathname, event.type+" - "+event.position, BCLcurrentVideoNAME+" - "+BCLcurrentVideoID]);
                    break;
                case "mediaChange":
                    _gaq.push(['_trackEvent', location.pathname, event.type+" - "+event.position, BCLcurrentVideoNAME+" - "+BCLcurrentVideoID]);
                    break;
                case "mediaComplete":
                    _gaq.push(['_trackEvent', location.pathname, event.type+" - "+event.position, BCLcurrentVideoNAME+" - "+BCLcurrentVideoID]);
                    break;
                default:
                    _gaq.push(['_trackEvent', location.pathname, event.type, BCLcurrentVideoNAME+" - "+BCLcurrentVideoID]);
            }
        }

    </script>
    <script>
        customBC.createPlaylist("<%=width%>","<%=height%>","<%=playerID%>","<%=playerKey%>","<%=properties.get("videoPlayerPL","")%>","<%=VideoRandomID %>");
    </script>
</div>
