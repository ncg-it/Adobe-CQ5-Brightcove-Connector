<%@include file="/apps/brightcove/global/global.jsp" %>
<%

%>

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