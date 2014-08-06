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



 *//*vm_wire.js
*functions for communication
 */
 
/********************** 
*The Ajile library is used *
*to parse json responses  *
**********************/
 
/*!***************************!*
*!! write functionality disabled:      *
* the functions for write methods  *
* have been modified, they are not *
* good examples.  Please see the     *
* actual docs for this page to see   *
* how the write methods work.        *
******************************/
 
//CONFIG 
//This should be set to point to proxy.jsp on your server
var apiLocation = "/apps/brightcove/console/brightcove.proxy.html";


//Default Fields
//specifying a subset of fields cuts down on the amount of data sent over the wire.  If you want to access another field, include it here.
var fields = "id,name,shortDescription,longDescription,publishedDate,lastModifiedDate,linkURL,linkText,tags,thumbnailURL,referenceId,length,economics,videoStillURL";
//END CONFIG

//oCurrentVideoList and oCurrentPlaylistList hold the JSON data about videos and playlists
var oCurrentVideoList;
var oCurrentPlaylistList;

function getAllVideosURL() {
	$(".sortable", $("#nameCol").parent()).not($("#nameCol")).addClass("NONE");
	$("#nameCol").removeClass("ASC");
	$("#nameCol").removeClass("DESC");
	$("#nameCol").removeClass("NONE");
	$("#nameCol").addClass("ASC");
	$("#nameCol").attr("data-sortType","ASC");
	return getAllVideosURLOrdered("DISPLAY_NAME","ASC");
    
}
function getAllVideosURLOrdered(sort_by, sort_type) {
    loadStart();
    //If currentFunction == this function name, then the current view already correspdonds to this function, so use the generic holder value
    //otherwise, we're switching from a different view so use the last stored value.
    paging.allVideos = (paging.currentFunction == getAllVideosURL)?paging.generic:paging.allVideos;
    paging.currentFunction = getAllVideosURL;
    if(typeof searchField != "undefined" && searchVal != "" && searchVal != "Search Videos"){
        if (!isNumber(searchVal)) {
        	if (typeof searchField == "undefined" || searchField == "every_field" || searchField == "") {
		        return apiLocation +
		        '?command=search_videos&callback=showAllVideosCallBack&any=search_text:'+searchVal+'&sort_by='+sort_by+"%3A"+sort_type
		            + '&any=tag:'+searchVal+'&get_item_count=true&page_size=' + paging.size + '&page_number='+paging.textSearch
		            +'&fields='+fields;
        	} else {
        		return apiLocation +
		        '?command=search_videos&callback=showAllVideosCallBack&any='+searchField+':'+searchVal+'&sort_by='+sort_by+"%3A"+sort_type
		            + '&get_item_count=true&page_size=' + paging.size + '&page_number='+paging.textSearch
		            +'&fields='+fields;
        	}
        } else {
        	return apiLocation +
	        '?command=find_videos_by_ids&callback=showAllVideosCallBack&video_ids='+searchVal
	            + '&get_item_count=true&fields='+fields; 
        }
    } else {
	    return apiLocation +
	     '?command=search_videos&callback=showAllVideosCallBack&sort_by='+sort_by+"%3A"+sort_type
	        + '&get_item_count=true&page_size=' + paging.size + '&page_number='+paging.allVideos
	        +'&fields='+fields;
    }
}

function isNumber(n) {
	  return !isNaN(parseFloat(n)) && isFinite(n);
	}
function getAllPlaylistsURL(){
    loadStart();
    paging.allPlaylists = (paging.currentFunction == getAllPlaylistsURL)?paging.generic:paging.allPlaylists;
    paging.currentFunction = getAllPlaylistsURL;
    return apiLocation +
    '?command=find_all_playlists&callback=showAllPlaylistsCallBack'
        + '&get_item_count=true&page_size=' + paging.size + '&page_number='+paging.allPlaylists;
}

function getFindPlaylistsURL(){
    loadStart();
    paging.allPlaylists = (paging.currentFunction == getAllPlaylistsURL)?paging.generic:paging.allPlaylists;
    paging.currentFunction = getAllPlaylistsURL;
    if(searchVal != "" && searchVal != "Search Playlists"){
    	if (searchField == "find_playlist_by_id") {
		    return apiLocation +
		    '?command=find_playlists_by_ids&playlist_ids='+searchVal+'&callback=showSearchPlaylistsCallBack'
		        + '&get_item_count=true&page_size=' + paging.size + '&page_number='+paging.allPlaylists;
    	} else if (searchField == "find_playlist_by_reference_id") {
    		return apiLocation +
		    '?command=find_playlists_by_reference_ids&reference_ids='+searchVal+'&callback=showSearchPlaylistsCallBack'
		        + '&get_item_count=true&page_size=' + paging.size + '&page_number='+paging.allPlaylists;
    	}
    } else {
    	return apiLocation +
        '?command=find_all_playlists&callback=showAllPlaylistsCallBack'
            + '&get_item_count=true&page_size=' + paging.size + '&page_number='+paging.allPlaylists;
    }
}
function searchVideoURL(){
    loadStart();
    paging.textSearch = (paging.currentFunction == searchVideoURL)?paging.generic:paging.textSearch;
    paging.currentFunction  = searchVideoURL;
    var sort_by = $("#trHeader th.sortable").not("NONE").attr("data-sortby");
    var data_sorttype = $("#trHeader th.sortable").not("NONE").attr("data-sorttype");
    if(searchVal != "" && searchVal != "Search Videos"){
        if (!isNumber(searchVal)) {
        	if (searchField == "every_field" || searchField == "" || typeof searchField == "undefined") {
		        return apiLocation +
		        '?command=search_videos&sort_by='+sort_by+'%3A'+data_sorttype+'&callback=searchVideoCallBack&any=search_text:'+searchVal
		            + '&any=tag:'+searchVal+'&get_item_count=true&page_size=' + paging.size + '&page_number='+paging.textSearch
		            +'&fields='+fields;
        	} else {
        		return apiLocation +
		        '?command=search_videos&sort_by='+sort_by+'%3A'+data_sorttype+'&callback=searchVideoCallBack&any='+searchField+':'+searchVal
		            + '&get_item_count=true&page_size=' + paging.size + '&page_number='+paging.textSearch
		            +'&fields='+fields;
        	}
        } else {
        	return apiLocation +
	        '?command=find_videos_by_ids&callback=searchVideoCallBack&video_ids='+searchVal
	            + '&get_item_count=true&fields='+fields; 
        }
    }
}

function findByTag(){
    loadStart();
    paging.tagSearch = (paging.currentFunction == findByTag)?paging.generic:paging.tagSearch;
    paging.currentFunction = findByTag;
    return apiLocation + '?command=find_videos_by_tags&and_tags='+searchVal+
        '&get_item_count=true&page_size='+paging.size+'&page_number='+paging.tagSearch+'&callback=findByTagCallBack&fields='
        +fields;
}

/*delete_video is a write method, and needs to be submitted to the api server as a multipart/post request.
* however, since there are only a few fields of data being sent from this request, we'll send it as a GEt request to the proxy
* server and let it format the multipart request.~
* the line '}else if ( write_methods.contains(request.getParameter("command")) && request.getMethod() == "GET"){'
* in proxy.jsp handles this kind of request.
*/
function deleteVideoURL(videoId){
    loadStart();
    return apiLocation + '?command=delete_video&ids='+videoId+'&callback=showAllVideosCallBack';
    
}

function showAllVideosCallBack(o) {
    if(null == o.error){
        oCurrentVideoList = o.items;
        buildMainVideoList("All Videos");
        doPageList(o.total_count, "Videos");
    }else{
        var message = (null!=o.error.message)?o.error.message:o.error;
        alert("Server Error: "+ message);
    }
    loadEnd();
}

function showSearchPlaylistsCallBack(o){
    if(null == o.error){
        oCurrentPlaylistList = o.items;
        buildPlaylistList();
        var total = o.total_count;
        if (total< o.items.length)total =   o.items.length;
        doPageList(total, "Playlists");
    }else{
        var message = (null!=o.error.message)?o.error.message:o.error;
        alert("Server Error: "+ message);
    }
    loadEnd();
}
function showAllPlaylistsCallBack(o){
    if(null == o.error){
        oCurrentPlaylistList = o.items;
        buildPlaylistList();
        doPageList(o.total_count, "Playlists");
    }else{
        var message = (null!=o.error.message)?o.error.message:o.error;
        alert("Server Error: "+ message);
    }
    loadEnd();
}

function searchVideoCallBack(o){
    if(null == o.error){
        oCurrentVideoList = o.items;
        buildMainVideoList("Search: "+searchVal);
        var count = (o.total_count >= 0) ? o.total_count : o.items.length;
        doPageList(count, "Videos");
    }else{  
        var message = (null!=o.error.message)?o.error.message:o.error;
        alert("Server Error: "+ message);
    }
    loadEnd();
}

function findByTagCallBack(o){
    if(null == o.error){
        oCurrentVideoList = o.items;
        buildMainVideoList("Tag Search: "+searchVal);
        doPageList(o.total_count, "Videos");
    }else{  
        var message = (null!=o.error.message)?o.error.message:o.error;
        alert("Server Error: "+ message);
    }
    loadEnd();
}

//Function calls update_video to change metadata
//Also see metaEdit in vm_ui.js
function metaSubmit(){
    var form = document.getElementById("metaEditForm");
    form.action = apiLocation;
    form.submit();
    loadStart();
    //noWrite();
    closeBox('metaEditPop');
    Load(getAllVideosURL());
}

function delConfYes(){
    var checkedVideos = $("#tblMainList input:checked");
    var IDs = "";
    checkedVideos.each(function() {
        IDs = IDs+$(this).val() + ",";
    }
    );
    Load(deleteVideoURL(IDs));
    closeBox('delConfPop');
    Load(getAllVideosURL());
}

function buildJSONRequest(form){
    if(document.getElementById('name').value =="" || document.getElementById('shortDescription').value =="" || document.getElementById('filePath').value ==""){
        alert("Require Name, Short Description and File");
        return;
    }else{
        json = document.getElementById('video').value
        //Construct the JSON request:
        json.value = '{"name": "' + 
        document.getElementById('name').value + '", "shortDescription": "' + document.getElementById('shortDescription').value + 
        '"}';
        document.getElementById('video').value = json.value;
    }
}
function startUpload(){
    var form = document.getElementById("uploadForm");
    buildJSONRequest(form);
    form.action = apiLocation;
    form.submit();
    loadStart();
    //noWrite();
    closeBox('uploadDiv', form);
    Load(getAllVideosURL());
}
function startExtUpload(window, formid){
    var form = document.getElementById(formid);
    buildJSONRequest(form);
    form.action = apiLocation;
    form.submit();
    loadStart();
    //noWrite();
    window.destroy();
    //closeBox('uploadDiv', form);
    Load(getAllVideosURL());
}
function startImageUpload(){
    var form = document.getElementById("uploadImageForm");
    form.action = apiLocation;
    form.submit();
    loadStart();
    //noWrite();
    closeBox('uploadImageDiv', form);
    Load(getAllVideosURL());
}
function startVideoImageUpload(){
    var form = document.getElementById("uploadVideoImageForm");
    form.action = apiLocation;
    form.submit();
    loadStart();
    //noWrite();
    closeBox('uploadVideoImageDiv', form);
    Load(getAllVideosURL());
}
//See createPlaylistBox for more info
function createPlaylistSubmit(){
    var form = document.getElementById("createPlaylistForm");
    
    form.action = apiLocation;
    form.submit();
    $('#createPlstVideoTable').empty();
    loadStart();
    //noWrite();
    closeBox('createPlaylistDiv', form);
    Load(getAllPlaylistsURL());
}

function modPlstSubmit(){
    loadStart();
    noWrite();
    closeBox('modPlstPop');
    Load(getAllPlaylistsURL());
}