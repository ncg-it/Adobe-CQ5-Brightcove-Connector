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
var BCLplayer;
var BCLexperienceModule;
var BCLvideoPlayer;
var BCLcurrentVideo;

//listener for player error
function onPlayerError(event) {
    /* */
}

//listener for when player is loaded
function onPlayerLoaded(id) {
  // newLog();
//  log("EVENT: onPlayerLoaded");
  BCLplayer = brightcove.getExperience(id);
  if (typeof BCLplayer!='undefined') BCLexperienceModule = BCLplayer.getModule(APIModules.EXPERIENCE);
}

//listener for when player is ready
function onPlayerReady(event) {
 // log("EVENT: onPlayerReady");

  // get a reference to the video player module
  BCLvideoPlayer = BCLplayer.getModule(APIModules.VIDEO_PLAYER);
  // add a listener for media change events
  BCLvideoPlayer.addEventListener(BCMediaEvent.BEGIN, onMediaBegin);
  BCLvideoPlayer.addEventListener(BCMediaEvent.COMPLETE, onMediaBegin);
  BCLvideoPlayer.addEventListener(BCMediaEvent.CHANGE, onMediaBegin);
  BCLvideoPlayer.addEventListener(BCMediaEvent.ERROR, onMediaBegin);
  BCLvideoPlayer.addEventListener(BCMediaEvent.PLAY, onMediaBegin);
  BCLvideoPlayer.addEventListener(BCMediaEvent.STOP, onMediaBegin);
}  
//listener for media change events
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

if (customBC == undefined) {
    var customBC = {};
    customBC.createElement = function (el) {
        if (document.createElementNS) {
            return document.createElementNS('http://www.w3.org/1999/xhtml', el);
        } else {
            return document.createElement(el);
        }
    };
    customBC.createVideo = function (width,height,playerID,playerKey,videoPlayer,VideoRandomID) {
    	var innerhtml = '<object id="myExperience_'+VideoRandomID+'" class="BrightcoveExperience">';
		innerhtml += '<param name="bgcolor" value="#FFFFFF" />';
		innerhtml += '<param name="width" value="'+width+'" />';
		innerhtml += '<param name="height" value="'+height+'" />';
		innerhtml += '<param name="playerID" value="'+playerID+'" />';
		innerhtml += '<param name="playerKey" value="'+playerKey+'" />';
		innerhtml += '<param name="isVid" value="true" />';
		innerhtml += '<param name="isUI" value="true" />';
		innerhtml += '<param name="dynamicStreaming" value="true" />';
		innerhtml += '<param name="@videoPlayer" value="'+videoPlayer+'" />';
		if ( window.location.protocol == 'https:') innerhtml += '<param name="secureConnections" value="true" /> ';
		innerhtml += '<param name="templateLoadHandler" value="onPlayerLoaded" />';
		innerhtml += '<param name="templateReadyHandler" value="onPlayerReady" />';
		innerhtml += '<param name="templateErrorHandler" value="onPlayerError" />';
		innerhtml += '<param name="includeAPI" value="true" /> ';
		innerhtml += '<param name="wmode" value="transparent" />';
		innerhtml += '</object>';
		var objID = document.getElementById(VideoRandomID);
		objID.innerHTML = innerhtml;
		
		var apiInclude = customBC.createElement('script');
		apiInclude.type = "text/javascript";
		apiInclude.src = "https://sadmin.brightcove.com/js/BrightcoveExperiences.js";
		objID.parentNode.appendChild(apiInclude);
		
		apiInclude = customBC.createElement('script');
		apiInclude.type = "text/javascript";
		apiInclude.src = "https://sadmin.brightcove.com/js/APIModules_all.js";
		objID.parentNode.appendChild(apiInclude);
		
		apiInclude = customBC.createElement('script');
		apiInclude.type = "text/javascript";
		apiInclude.src = "https://files.brightcove.com/bc-mapi.js";
		objID.parentNode.appendChild(apiInclude);
		
		apiInclude = customBC.createElement('script');
		apiInclude.type = "text/javascript";
		apiInclude.text  = "window.onload = function() {brightcove.createExperiences();};";
		objID.parentNode.appendChild(apiInclude);
    };
    customBC.createPlaylist = function (width,height,playerID,playerKey,videoPlayer,VideoRandomID) {
    	var innerhtml = '<object id="myExperience_'+VideoRandomID+'" class="BrightcoveExperience">';
		innerhtml += '<param name="bgcolor" value="#FFFFFF" />';
		innerhtml += '<param name="width" value="'+width+'" />';
		innerhtml += '<param name="height" value="'+height+'" />';
		innerhtml += '<param name="playerID" value="'+playerID+'" />';
		innerhtml += '<param name="playerKey" value="'+playerKey+'" />';
		innerhtml += '<param name="isVid" value="true" />';
		innerhtml += '<param name="isUI" value="true" />';
		innerhtml += '<param name="dynamicStreaming" value="true" />';
		innerhtml += '<param name="@playlistTabs" value="'+videoPlayer+'" />';
		if ( window.location.protocol == 'https:') innerhtml += '<param name="secureConnections" value="true" /> ';
		innerhtml += '<param name="templateLoadHandler" value="onPlayerLoaded" />';
		innerhtml += '<param name="templateReadyHandler" value="onPlayerReady" />';
		innerhtml += '<param name="templateErrorHandler" value="onPlayerError" />';
		innerhtml += '<param name="includeAPI" value="true" /> ';
		innerhtml += '<param name="wmode" value="transparent" />';
		innerhtml += '</object>';
		var objID = document.getElementById(VideoRandomID);
		objID.innerHTML = innerhtml;
		
		var apiInclude = customBC.createElement('script');
		apiInclude.type = "text/javascript";
		apiInclude.src = "https://sadmin.brightcove.com/js/BrightcoveExperiences.js";
		objID.parentNode.appendChild(apiInclude);
		
		apiInclude = customBC.createElement('script');
		apiInclude.type = "text/javascript";
		apiInclude.src = "https://sadmin.brightcove.com/js/APIModules_all.js";
		objID.parentNode.appendChild(apiInclude);
		
		apiInclude = customBC.createElement('script');
		apiInclude.type = "text/javascript";
		apiInclude.src = "https://files.brightcove.com/bc-mapi.js";
		objID.parentNode.appendChild(apiInclude);
		
		apiInclude = customBC.createElement('script');
		apiInclude.type = "text/javascript";
		apiInclude.text  = "window.onload = function() {brightcove.createExperiences();};";
		objID.parentNode.appendChild(apiInclude);
    };
}