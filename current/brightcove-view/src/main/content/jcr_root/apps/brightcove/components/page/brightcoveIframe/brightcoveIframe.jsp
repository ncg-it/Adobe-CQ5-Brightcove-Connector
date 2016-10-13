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

- Additional permission under GNU GPL version 3 section 7
If you modify this Program, or any covered work, by linking or combining
it with httpclient 4.1.3, httpcore 4.1.4, httpmine 4.1.3, jsoup 1.7.2,
squeakysand-commons and squeakysand-osgi (or a modified version of those
libraries), containing parts covered by the terms of APACHE LICENSE 2.0 
or MIT License, the licensors of this Program grant you additional 
permission to convey the resulting work.

--%>
<%@ page import="java.util.UUID" %>

<%@include file="/libs/foundation/global.jsp" %>

<body style="background:black;">
<%


    //Sample request: /etc/designs/brightcove_iframe.html?pk=AQ~~,AAAA2uzqPsk~,x6biOaTywG-S8Eb2e9BIzJibdsmcwx28&vp=1644607213001

    String playerID = request.getParameter("pid");
    String playerKey = request.getParameter("pk");
    String videoPlayer = request.getParameter("vp");

    boolean showVideo = true;

    if (playerID == null) {
        playerID = "940636285001";
    }
    if (playerKey == null || videoPlayer == null) {
        showVideo = false;
    }


    if (showVideo) {
        UUID video_uuid = new UUID(64L, 64L);
        String VideoRandomID = new String(video_uuid.randomUUID().toString().replaceAll("-", ""));
%>

<div style="margin-bottom: 0;margin-left:auto;margin-right:auto;margin-top: 0;overflow-x: hidden;overflow-y: hidden;text-align: center;width: 480px;text-align:center">
    <div id="<%=VideoRandomID %>">

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
                    _gaq.push(['_trackEvent', location.pathname, event.type + " - " + currentVideoLength, BCLcurrentVideoNAME + " - " + BCLcurrentVideoID]);
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
        customBC.createVideo("480", "270", "<%=playerID%>", "<%=playerKey%>", "<%=videoPlayer%>", "<%=VideoRandomID %>");
    </script>
</div>
<%} %>
</body>