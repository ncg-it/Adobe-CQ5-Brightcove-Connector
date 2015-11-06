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

<%@include file="/apps/brightcove/components/shared/global.jsp" %>

<%--

Actual player code is separated into smaller script to make overlaying the implementation easier by setting this component is set as the resourceSuperType.


*** All page context variables are set in the parent script which should include /apps/brightcove/components/shared/component-global.jsp ***

Available Variables:

        - ${brc_componentID}

        - ${brc_account}
        - ${brc_videoID}
        - ${brc_playlistID}

        - ${brc_playerID}
        - ${brc_playerKey}
        - ${brc_playerDataEmbed}

        - ${brc_hasSize}
        - ${brc_width}
        - ${brc_height}



Brightcove Reference:

      - http://docs.brightcove.com/en/video-cloud/brightcove-player/guides/embed-in-page.html
      - http://docs.brightcove.com/en/video-cloud/brightcove-player/guides/playlist-using.html#inpageembed

--%>

<div class="brightcove-container playlist-${brc_align}">


    <c:if test="${brc_align eq 'right'}">
        <%-- If the Alignment--%>
        <ol class="vjs-playlist"></ol>
    </c:if>
    <video
            id="video-${brc_componentID}"
            data-account="${brc_account}"
            data-player="${brc_playerID}"
            data-embed="${brc_playerDataEmbed}"
            data-playlist-id="${brc_playlistID}"
            <c:if test="${brc_hasSize}">
                width="${brc_width}px"
                height="${brc_height}px"
            </c:if>
            class="video-js"
            controls>
    </video>

    <%-- --%>
    <c:if test="${brc_align  ne 'right'}">
        <ol class="vjs-playlist"></ol>
    </c:if>



    <script src="//players.brightcove.net/${brc_account}/${brc_playerID}_${brc_playerDataEmbed}/index.min.js"></script>

</div>