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
<%@ page contentType="text/html"
         pageEncoding="utf-8"
         import="com.coresecure.brightcove.wrapper.sling.ConfigurationGrabber,
                 com.coresecure.brightcove.wrapper.sling.ConfigurationService,
                 com.coresecure.brightcove.wrapper.sling.ServiceUtil,
                 com.day.cq.i18n.I18n,
                 com.day.text.Text,
                 java.util.ResourceBundle" %>

<%@include file="/libs/foundation/global.jsp" %>

<%


    final ResourceBundle resourceBundle = slingRequest.getResourceBundle(null);
    I18n i18n = new I18n(resourceBundle);

    String segmentPath = Text.getRelativeParent(resource.getPath(), 1);

    String title = properties.get("jcr:title", Text.getName(segmentPath));
    String description = properties.get("jcr:description", "");
    String width = "480";
    String height = "270";
    String account = properties.get("account", "");
    String playerID = "";
    String playerKey = properties.get("playerKey", "");
    ;
    String data_embedded = "default";
    if (!account.trim().isEmpty()) {
        ConfigurationGrabber cg = ServiceUtil.getConfigurationGrabber();
        ConfigurationService cs = cg.getConfigurationService(account);
        if (cs != null) {
            playerID = cs.getDefVideoPlayerID();
            data_embedded = cs.getDefVideoPlayerDataEmbedded();
        }
    }
    data_embedded = properties.get("data_embedded", data_embedded);
    playerID = properties.get("playerID", playerID);

    ValueMap playerProperties = currentPage.getProperties();

    if (playerProperties.containsKey("width") && playerProperties.containsKey("height")) {

        width = playerProperties.get("width", String.class);
        height = playerProperties.get("height", String.class);
    } else if (playerProperties.containsKey("width") && !playerProperties.containsKey("height")) {
        width = playerProperties.get("width", String.class);
        height = String.valueOf(270 * playerProperties.get("width", 1) / 480);

    } else if (!playerProperties.containsKey("width") && playerProperties.containsKey("height")) {
        height = playerProperties.get("height", String.class);
        width = String.valueOf(480 * playerProperties.get("height", 1) / 270);
    }

    String dialogPath = "";
    if (editContext != null && editContext.getComponent() != null) {
        dialogPath = editContext.getComponent().getDialogPath();
    }

// Update Page Context

    pageContext.setAttribute("account", account);
    pageContext.setAttribute("playerID", playerID);
    pageContext.setAttribute("playerKey", playerKey);
    pageContext.setAttribute("data_embedded", data_embedded);

    pageContext.setAttribute("title", title);
    pageContext.setAttribute("description", description);

    pageContext.setAttribute("dialogPath", dialogPath);

    pageContext.setAttribute("width", width);
    pageContext.setAttribute("height", height);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html>
<head>
    <title>${title} | Brightcove Player</title>

    <meta http-equiv="Content-Type" content="text/html; utf-8"/>

    <cq:includeClientLib categories="cq.wcm.edit"/>

    <script src="/libs/cq/ui/resources/cq-ui.js" type="text/javascript"></script>
    <script type="text/javascript">
        CQ.WCM.launchSidekick("${currentPage.path}", {
            propsDialog: "${dialogPath}",
            locked: ${currentPage.locked}
        });
    </script>

    <style type="text/css">
        .edit-box {
            width: 75%;
        }
    </style>

</head>

<body>

<h1>Brightcove Player Config | &quot;${title}&quot;</h1>

<div class="definition-container">
    <p>${description}</p>
</div>


<cq:text value="Player ID" tagName="h2" tagClass="no-icon"/>

<p>Use the Page Properties editor to edit the Player ID.</p>

<div class="edit-box">
    <cq:text property="playerID" placeholder="NONE" tagName="strong"/>
</div>

<cq:text value="Player Key" tagName="h2" tagClass="no-icon"/>

<p>Use the Page Properties editor to edit the Player Key.</p>

<div class="edit-box">
    <cq:text property="playerKey" placeholder="NONE" tagName="strong"/>
</div>

<cq:text value="Player Preview" tagName="h2" tagClass="no-icon"/>
<p></p>

<div class="edit-box">
    <c:choose>
        <c:when test="${empty playerKey}">
            <ul>
                <li>
                    Account: <strong>${account}</strong>
                </li>
                <li>
                    Player ID: <strong>${playerID}</strong>
                </li>
                <li>
                    data_embedded: <strong>${data_embedded}</strong>
                </li>
            </ul>
            <video
                    data-account="${account}"
                    data-player="${playerID}"
                    data-embed="${data_embedded}"
                    data-video-id=""
                    class="video-js"
                    width="${width}px"
                    height="${height}px"
                    class="video-js" controls>
            </video>
            <script src="//players.brightcove.net/${account}/${playerID}_${data_embedded}/index.min.js"></script>
        </c:when>
        <c:otherwise>
            <c:if test="${(not empty width) and (not empty height)}">

                <!-- DO NOT USE!!!! FOR PREVIEW PURPOSES ONLY. -->

                <!-- Start of Brightcove Player -->

                <div style="display:none;"></div>
                <!--
                By use of this code snippet, I agree to the Brightcove Publisher T and C
                found at https://accounts.brightcove.com/en/terms-and-conditions/.
                -->

                <script language="JavaScript" type="text/javascript"
                        src="https://sadmin.brightcove.com/js/BrightcoveExperiences.js"></script>

                <object id="myExperience" class="BrightcoveExperience">
                    <param name="bgcolor" value="#FFFFFF"/>
                    <param name="width" value="${width}"/>
                    <param name="height" value="${height}"/>
                    <param name="playerID" value="${playerID}"/>
                    <param name="playerKey" value="${playerKey}"/>
                    <param name="isVid" value="true"/>
                    <param name="isUI" value="true"/>
                    <param name="dynamicStreaming" value="true"/>
                    <param name="cacheAMFURL" value="//share.brightcove.com/services/messagebroker/amf"/>
                    <param name="secureConnections" value="true"/>
                </object>

                <!--
                This script tag will cause the Brightcove Players defined above it to be created as soon
                as the line is read by the browser. If you wish to have the player instantiated only after
                the rest of the HTML is processed and the page load is complete, remove the line.
                -->
                <script type="text/javascript">brightcove.createExperiences();</script>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>