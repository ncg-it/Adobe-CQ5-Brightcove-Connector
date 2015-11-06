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

<cq:include script="inline-styles.jsp"/>

<%-- Allow for inline CSS to be added at the component level for tweaks --%>
<c:if test="${not empty properties['inlineCSS']}">
    <style type="text/css">
        <c:out value="${properties['inlineCSS']}" escapeXml="true"/>
    </style>
</c:if>


<div id="${brc_containerID}" class="${brc_containerClass}">
    <div id="component-wrap-${brc_componentID}" class="brc-align-${brc_align}">
        <c:choose>
            <c:when test="${(not empty brc_account) or (not empty brc_playerID)}">

                <div data-sly-test="${isEditMode}"
                     class="cq-dd-brightcove_player md-dropzone-video drop-target-player"
                     data-sly-text="Drop player here">

                    <c:if test="${(not empty brc_videoID) or (not empty brc_playlistID)}">

                            <cq:include script="player-embed.jsp"/>

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
</div>
<%

    /*** Cleanup all Page Context attributes bound to Request in /apps/brightcove/components/shared/component-global.jsp ***/

    pageContext.removeAttribute("brc_componentID");

    pageContext.removeAttribute("brc_account");
    pageContext.removeAttribute("brc_videoID");
    pageContext.removeAttribute("brc_playlistID");

    pageContext.removeAttribute("brc_playerPath");
    pageContext.removeAttribute("brc_playerID");
    pageContext.removeAttribute("brc_playerKey");
    pageContext.removeAttribute("brc_playerDataEmbed");

    pageContext.removeAttribute("brc_align");
    pageContext.removeAttribute("brc_width");
    pageContext.removeAttribute("brc_height");
    pageContext.removeAttribute("brc_hasSize");

    pageContext.removeAttribute("brc_containerID");
    pageContext.removeAttribute("brc_containerClass");

%>
