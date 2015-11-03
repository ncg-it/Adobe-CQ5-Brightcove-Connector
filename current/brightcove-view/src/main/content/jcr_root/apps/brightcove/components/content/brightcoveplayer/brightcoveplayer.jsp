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

<%@include file="/apps/brightcove/components/shared/component-global.jsp" %>

<%


%>

<style type="text/css">

    #component-wrap-${brc_componentID} {

    }

    #component-wrap-${brc_componentID} .drop-target-player {
        margin-bottom: 0;
        margin-left: ${brc_marginLeft};
        margin-right: ${brc_marginRight};
        margin-top: 0;
        overflow-x: hidden;
        overflow-y: hidden;
        width: 100%;
        text-align: ${brc_position};
    }

    #component-wrap-${brc_componentID} .drop-target-video {
        width: 99%;
    }

    #component-wrap-${brc_componentID} .brightcove-container {
        width: 100%;
    }


</style>

<c:if test="${brc_hasSize}">
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

<cq:include script="style.jsp"/>

<div id="component-wrap-${brc_componentID}">
    <c:choose>
        <c:when test="${(not empty brc_account) or (not empty brc_playerID)}">

            <div data-sly-test="${isEditMode}"
                 class="cq-dd-brightcove_player md-dropzone-video drop-target-player"
                 data-sly-text="Drop player here">

                <c:if test="${(not empty brc_videoID) or (not empty brc_playlistID)}">

                    <div class="brightcove-container">

                        <cq:include script="player-embed.jsp"/>

                    </div>
                </c:if>
                <c:if test="${isEditMode}">
                    <div data-sly-test="${isEditMode}"
                         class="cq-dd-brightcove_video cq-video-placeholder cq-block-sm-placeholder md-dropzone-video drop-target-video"
                         data-sly-text="Drop video here"></div>
                </c:if>
            </div>
        </c:when>
        <c:otherwise>
            <div data-sly-test="${isEditMode}"
                 class="cq-dd-brightcove_player cq-video-placeholder cq-block-sm-placeholder md-dropzone-video drop-target-player-empty"
                 data-sly-text="Drop player here"></div>
        </c:otherwise>
    </c:choose>
</div>

<%

    /*** Cleanup All Page Context Variables defined in /apps/brightcove/components/shared/component-global.jsp ***/

    pageContext.removeAttribute("brc_componentID");

    pageContext.removeAttribute("brc_account");
    pageContext.removeAttribute("brc_videoID");
    pageContext.removeAttribute("brc_playlistID");

    pageContext.removeAttribute("brc_playerPath");
    pageContext.removeAttribute("brc_playerID");
    pageContext.removeAttribute("brc_playerKey");
    pageContext.removeAttribute("brc_playerDataEmbed");

    pageContext.removeAttribute("brc_position");
    pageContext.removeAttribute("brc_marginLeft");
    pageContext.removeAttribute("brc_marginRight");
    pageContext.removeAttribute("brc_width");
    pageContext.removeAttribute("brc_height");
    pageContext.removeAttribute("brc_hasSize");

%>
