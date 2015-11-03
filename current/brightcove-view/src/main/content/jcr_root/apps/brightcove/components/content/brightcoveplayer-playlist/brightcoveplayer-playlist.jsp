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
                 com.coresecure.brightcove.wrapper.sling.ServiceUtil" %>

<%@include file="/apps/brightcove/components/shared/component-global.jsp" %>

<%

    /*** Reference ***/
    //  - http://docs.brightcove.com/en/video-cloud/brightcove-player/guides/embed-in-page.html
    //  - http://docs.brightcove.com/en/video-cloud/brightcove-player/guides/playlist-using.html#inpageembed

//    String marginLeft = "auto";
//    String marginRight = "auto";
//    String position = properties.get("align", "center");
//    String width = "480";
//    String height = "270";
//    boolean hasSize = false;
//    String playerPath = properties.get("playerPath", "").trim();
//    String videoPlayer = properties.get("videoPlayerPL", "").trim();
//    String account = properties.get("account", "").trim();
//    String playerID = "";
//    String data_embedded = "";
//    if (!account.isEmpty()) {
//        ConfigurationGrabber cg = ServiceUtil.getConfigurationGrabber();
//        ConfigurationService cs = cg.getConfigurationService(account);
//        if (cs != null) {
//            playerID = cs.getDefVideoPlayerID();
//            data_embedded = cs.getDefVideoPlayerDataEmbedded();
//        }
//    }
//
//
//    if (!playerPath.isEmpty()) {
//
//        Page playerPage = resourceResolver.resolve(playerPath).adaptTo(Page.class);
//        ValueMap playerProperties = playerPage.getProperties();
//        String playerAccount = playerProperties.get("account", account);
//        if (account.isEmpty() && playerProperties.containsKey("account")) {
//            try {
//                currentNode.setProperty("account", playerAccount);
//                currentNode.save();
//            } catch (RepositoryException e) {
//                e.printStackTrace();
//            }
//        }
//        request.setAttribute("account", playerAccount);
//        if (playerProperties.containsKey("playerID")) {//} && playerProperties.containsKey("playerKey")) {
//            playerID = playerProperties.get("playerID", playerID);
//            data_embedded = playerProperties.get("data_embedded", data_embedded);
//        }
//        position = playerProperties.get("align", position);
//        if (position.equals("left")) {
//            marginLeft = "0";
//        } else if (position.equals("right")) {
//            marginRight = "0";
//        }
//        if (playerProperties.containsKey("width") && playerProperties.containsKey("height")) {
//
//            width = playerProperties.get("width", String.class);
//            height = playerProperties.get("height", String.class);
//            hasSize = true;
//        } else if (playerProperties.containsKey("width") && !playerProperties.containsKey("height")) {
//            width = playerProperties.get("width", String.class);
//            height = String.valueOf(270 * playerProperties.get("width", 1) / 480);
//            hasSize = true;
//
//        } else if (!playerProperties.containsKey("width") && playerProperties.containsKey("height")) {
//            height = playerProperties.get("height", String.class);
//            width = String.valueOf(480 * playerProperties.get("height", 1) / 270);
//            hasSize = true;
//
//        }
//    }
//
//    // Update Page Context
//
//    pageContext.setAttribute("account", account);
//    pageContext.setAttribute("videoPlayer", videoPlayer);
//    pageContext.setAttribute("playerPath", playerPath);
//
//    pageContext.setAttribute("playerID", playerID);
//    pageContext.setAttribute("data_embedded", data_embedded);
//
//
//    pageContext.setAttribute("position", position);
//
//    pageContext.setAttribute("marginLeft", marginLeft);
//    pageContext.setAttribute("marginRight", marginRight);
//    pageContext.setAttribute("width", width);
//    pageContext.setAttribute("height", height);
//
//    pageContext.setAttribute("hasSize", hasSize);


%>

<style>

    #component-wrap-${brc_componentID} {

    }

    #component-wrap-${brc_componentID} .drop-target-player {
        margin-bottom: 0;
        margin-left: ${marginLeft};
        margin-right: ${marginRight};
        margin-top: 0;
        overflow-x: hidden;
        overflow-y: hidden;
        text-align: center;
        width: 100%;
        text-align: ${position};
    }

    #component-wrap-${brc_componentID} .drop-target-video {
        width: 99%;
    }

    #component-wrap-${brc_componentID} .brightcove-container {
        width: 100%;
    }

    <c:if test="${false}">
    /*playlist style*/
    #component-wrap-${brc_componentID} .brightcove-container .video-js {
        float: left;
        margin: 15px;
    }

    #component-wrap-${brc_componentID} .brightcove-container .vjs-playlist {
        width: 250px;
        float: left;
        margin: 15px;
    }

    </c:if>


</style>

<c:if test="${hasSize}">
    <style type="text/css">
        #component-wrap-${brc_componentID} .brightcove-container {
            width: 80%;
            display: block;
            position: relative;
            margin: 20px auto;
        }

        #component-wrap-${brc_componentID} .brightcove-container:after {
            padding-top: 56.25%;
            display: block;
            content: '';
        }

        #component-wrap-${brc_componentID} .brightcove-container object {
            position: absolute;
            top: 0;
            bottom: 0;
            right: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
    </style>
</c:if>

<div id="component-wrap-${brc_componentID}">
    <c:choose>
        <c:when test="${(not empty account) or (not empty playerPath)}">

            <div data-sly-test="${wcmmode.edit}"
                 class="cq-dd-brightcove_player md-dropzone-video drop-target-player"
                 data-sly-text="Drop player here">

                <c:if test="${not empty videoPlayer}">
                    <div class="brightcove-container">
                        <video
                                id="video-${brc_componentID}"
                                data-account="${account}"
                                data-player="${playerID}"
                                data-embed="${data_embedded}"
                                data-playlist-id="${videoPlayer}"
                                class="video-js"
                                <c:if test="${hasSize}">
                                    width="${width}px"
                                    height="${height}px"
                                </c:if>
                                class="video-js"
                                controls>
                                <%--
                                    autoplay
                                    height	Sets the display height of the video
                                    loop	boolean - Causes the video to start over as soon as it ends.
                                    muted	boolean - Mutes the videos sound
                                    poster	Sets the image that displays before the video begins playing. This is often a frame of the video or a custom title screen. As soon as the user clicks play the image will go away.
                                    preload	boolean - Informs the browser whether or not the video data should begin downloading as soon as the video tag is loaded.
                                    width	Sets the display width of the video
                                    --%>
                        </video>

                        <ol class="vjs-playlist"></ol>

                        <script src="//players.brightcove.net/${account}/${playerID}_${data_embedded}/index.min.js"></script>

                    </div>
                </c:if>
                <c:if test="${isEditMode}">
                    <div data-sly-test="${wcmmode.edit}"
                         class="cq-dd-brightcove_video cq-video-placeholder cq-block-sm-placeholder md-dropzone-video drop-target-video"
                         data-sly-text="Drop video here"></div>
                </c:if>
            </div>
        </c:when>
        <c:otherwise>
            <div data-sly-test="${wcmmode.edit}"
                 class="cq-dd-brightcove_player cq-video-placeholder cq-block-sm-placeholder md-dropzone-video  drop-target-player-empty"
                 data-sly-text="Drop player here"></div>
        </c:otherwise>
    </c:choose>
</div>