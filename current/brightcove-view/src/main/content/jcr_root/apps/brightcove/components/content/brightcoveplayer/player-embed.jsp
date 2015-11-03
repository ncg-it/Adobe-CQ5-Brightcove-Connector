<%@include file="/apps/brightcove/global/global.jsp" %>
<%

%>
EMBED
<strong>brc_componentID:</strong> ${brc_componentID}
<br/>
<strong>componentID:</strong> ${componentID}
<br/>
<strong>test:</strong> ${test}


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

    #component-wrap-${componentID} .drop-target-video {
        width: 99%;
    }

    #component-wrap-${componentID} .brightcove-container {
        width: 100%;
    }


</style>

<video
        id="video-${componentID}"
        data-account="${account}"
        data-player="${playerID}"
        data-embed="${data_embedded}"
        data-video-id="${videoPlayer}"
        class="video-js"
        <c:if test="${hasSize}">
            width="${width}px"
            height="${height}px"
        </c:if>
        class="video-js" controls>
</video>
<script src="//players.brightcove.net/${account}/${playerID}_${data_embedded}/index.min.js"></script>
