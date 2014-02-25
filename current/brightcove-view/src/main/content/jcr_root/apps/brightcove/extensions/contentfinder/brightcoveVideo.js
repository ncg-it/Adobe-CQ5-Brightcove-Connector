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
{
    "tabTip": CQ.I18n.getMessage("Brightcove"),
    "id": "cfTab-Brightcove",
    "iconCls": "cq-cft-tab-icon brightcove",
    "xtype": "contentfindertab",
    "ranking": 30,
    "allowedPaths": [
                     "/content/*",
                     "/etc/scaffolding/*",
                     "/etc/workflow/packages/*"
                 ],
    "items": [
       CQ.wcm.ContentFinderTab.getQueryBoxConfig({
            "id": "cfTab-Brightcove-QueryBox",
            "items": [
                CQ.wcm.ContentFinderTab.getSuggestFieldConfig({"url": "/bin/brightcove/suggestions.json?type=videos"})
            ]
        }),
        CQ.wcm.ContentFinderTab.getResultsBoxConfig({
            "itemsDDGroups": [CQ.wcm.EditBase.DD_GROUP_ASSET],
            "itemsDDNewParagraph": {
                "path": "brightcove/components/content/brightcovevideo",
                "propertyName": "./videoPlayer"
            },
            "noRefreshButton": true,
            "items": {
                "tpl":
                    '<tpl for=".">' +
                            '<div class="cq-cft-search-item" title="{thumbnailURL}" ondblclick="window.location=\'/apps/brightcove/console/brightcove.html\';">' +
                                    '<div class="cq-cft-search-thumb-top"' +
                                    ' style="background-image:url(\'{thumbnailURL}\');"></div>' +
                                         '<div class="cq-cft-search-text-wrapper">' +
                                            '<div class="cq-cft-search-title"><p class="cq-cft-search-title">{name}</p><p>{path}</p></div>' +
                                        '</div>' +
                                    '<div class="cq-cft-search-separator"></div>' +
                            '</div>' +
                    '</tpl>',
                "itemSelector": CQ.wcm.ContentFinderTab.DETAILS_ITEMSELECTOR
            },
            "tbar": [
                CQ.wcm.ContentFinderTab.REFRESH_BUTTON,"->",
                {
                    text: "Export CSV",
                    handler: function() {
                        var url='/bin/brightcove/api?a=3&query='+$("#cfTab-Brightcove-QueryBox input[name=query]").val();  
                        window.open(url, 'Download');

                   }
                }
            ]
        },{
            "url": "/bin/brightcove/api?a=2"
        },{
            "autoLoad":false,
            "reader": new CQ.Ext.data.JsonReader({
                "root": "items",
                "fields": [
                    "name", "path", "thumbnailURL"
                ],
                "id": "path"
                
            })
        
        })
    ]

}