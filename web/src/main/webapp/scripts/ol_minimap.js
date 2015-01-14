/*
 * Copyright (C) 2001-2011 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This file is part of GeoNetwork
 *
 * GeoNetwork is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * GeoNetwork is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GeoNetwork.  If not, see <http://www.gnu.org/licenses/>.
 */
Ext.namespace('GeoNetwork');

// create application
GeoNetwork.miniapp = function() {
    // private vars:
    var toolbar, viewport;

    var miniMap;
    
    var synchMinimaps = [];
    
    var extentBox;
  
    var regionControl;
    
    /**
     * Creates the OL Map 
     *
     */
    var createMap = function(mapOptions) {
        var options = mapOptions || {
            projection: "EPSG:4326",
            units: "m",
            maxExtent: new OpenLayers.Bounds(-180,-90,180,90),
            restrictedExtent: new OpenLayers.Bounds(-180,-90,180,90),
            controls: []
        };
        
        if (!options.controls) options.controls = [];
        miniMap = new OpenLayers.Map(options);
    };

    /**
     * Adds a layer to the map 
     *
     */
    var createWmsLayer = function(name, url, params, options) {
        miniMap.addLayer(new OpenLayers.Layer.WMS(name, url, params, options));
    };

    /**
     * Configure the map controls
     *
     */
    var addMapControls = function() {
        miniMap.addControl(new GeoNetwork.Control.ZoomWheel());
        miniMap.addControl(new OpenLayers.Control.LoadingPanel());
    };

    var setRegionControl = function(region) {
        regionControl = $(region);
    }
    
    /**
     * Creates the minimap map toolbar
     */
    var createToolbar = function(extentBoxIds) {
        toolbar = [];

        action = new GeoExt.Action({
            control: new OpenLayers.Control.ZoomToMaxExtent(),
            map: miniMap,
            iconCls: 'zoomfull',
            tooltip: {title: OpenLayers.i18n("zoomToMaxExtentTooltipTitle"), text: OpenLayers.i18n("zoomToMaxExtentTooltipText")}
        });
    
        toolbar.push(action);

        toolbar.push("-");

        action = new GeoExt.Action({
            control: new OpenLayers.Control.ZoomBox(),
            map: miniMap,
            toggleGroup: "move",
            allowDepress: false,
            iconCls: 'zoomin',
            tooltip: {title: OpenLayers.i18n("zoominTooltipTitle"), text: OpenLayers.i18n("zoominTooltipText")}
        });

        toolbar.push(action);

        action = new GeoExt.Action({
            control:  new OpenLayers.Control.ZoomBox({
                displayClass: 'ZoomOut',
                out: true
            }),
            map: miniMap,
            toggleGroup: "move",
            allowDepress: false,
            tooltip: {title: OpenLayers.i18n("zoomoutTooltipTitle"), text: OpenLayers.i18n("zoomoutTooltipText")},
            iconCls: 'zoomout'
        });

        toolbar.push(action);

        action = new GeoExt.Action({
            control: new OpenLayers.Control.DragPan({
                    isDefault: true
                }),
            toggleGroup: "move",
            allowDepress: false,
            pressed: true,
            map: miniMap,
            iconCls: 'pan',
            tooltip:  {title: OpenLayers.i18n("dragTooltipTitle"), text: OpenLayers.i18n("dragTooltipText")}
        });

        toolbar.push(action);

        toolbar.push("-");

        extentBox = new GeoNetwork.Control.ExtentBox({
                minxelement: Ext.get(extentBoxIds.westBL), 
                maxxelement: Ext.get(extentBoxIds.eastBL),
                minyelement: Ext.get(extentBoxIds.southBL),
                maxyelement: Ext.get(extentBoxIds.northBL)
         });

        
        extentBox.events.register("finishBox", null, function(evt) {
             regionControl.selectedIndex=1;
             
             if (synchMinimaps) {
						 	for (var i = 0; i < synchMinimaps.length; i++) {
                synchMinimaps[i].synch(regionControl.selectedIndex, extentBox);
							}
             }
        });
        
        action = new GeoExt.Action({
            control: extentBox,
            toggleGroup: "move",
            allowDepress: false,
            map: miniMap,
            tooltip: {title: OpenLayers.i18n("selectExtentTooltipTitle"), text: OpenLayers.i18n("selectExtentTooltipText")},
            iconCls: 'selextent'
        });

        toolbar.push(action);
        
    }

    /**
     * Refreshes the map zooming to the extent box
     */
    var updateMap = function updateMap(zoom) {
        if (extentBox) {
                extentBox.updateMap();
                if(zoom) extentBox.zoomTo();                    
        }                       
    };


    /**
     * Creates the map viewport
     *
     */
    var createViewport = function(miniMapDiv, extentBoxIds) {	 
        createToolbar(extentBoxIds);
         
        var mapPanel = new GeoExt.MapPanel({
            id: "mini_mappanel_" + miniMapDiv,
            renderTo: miniMapDiv,
            height: 150,
            width: 210,
            border:false,
            map: miniMap,
            tbar: toolbar
        });
    };

    /**
     * Clears the extent box
     */
    var clearExtentBox = function clearExtentBox() {
        if (extentBox) {
            extentBox.clear();
						// surprisingly the Ext set({value:''}) method doesn't work!?
						extentBox.minxelement.dom.value = '';
						extentBox.minyelement.dom.value = '';
						extentBox.maxxelement.dom.value = '';
						extentBox.maxyelement.dom.value = '';
            miniMap.zoomToMaxExtent();
        }
    }

    var osm_getTileURL = function(bounds) {
        var res = this.miniMap.getResolution();
        var x = Math.round((bounds.left - this.maxExtent.left) / (res * this.tileSize.w));
        var y = Math.round((this.maxExtent.top - bounds.top) / (res * this.tileSize.h));
        var z = this.map.getZoom();
        var limit = Math.pow(2, z);

        if (y < 0 || y >= limit) {
          return OpenLayers.Util.getImagesLocation() + "404.png";
        } else {
          x = ((x % limit) + limit) % limit;
          return this.url + z + "/" + x + "/" + y + "." + this.type;
        }
      }

    // public space:
    return {
        init: function(miniMapDiv, regionControl, layers, mapOptions, extentBoxIds) {
            if (!$(miniMapDiv)) return;
            Ext.QuickTips.init();

            setRegionControl(regionControl);
            
            createMap(mapOptions);

            for (var i=0; i<layers.length; i++) {                
//                createWmsLayer(layers[i][0],layers[i][1],layers[i][2],layers[i][3]);
            }

//    var createWmsLayer = function(name, url, params, options) {
//        miniMap.addLayer(new OpenLayers.Layer.WMS(name, url, params, options));
//    };
//        miniMap.addLayer(new OpenLayers.Layer.WMS(name, url, params, options));
//
//          http://undefined.tile.openweathermap.org/map/precipitation/2/3/3.png
//            miniMap.addLayer(new OpenLayers.Layer.TMS(name, url, params, options));


//            miniMap.addLayer(new OpenLayers.Layer.TMS(
//                "Precipitazioni",
//                "http://undefined.tile.openweathermap.org/map/",
//                {layername: 'precipitation', type: 'png', visibility: true,  isBaseLayer: true, serviceVersion:''}));


/****
 * BASELAYER
 */
    var topo_waterarea_epsg31287_tms_layer = new OpenLayers.Layer.TMS( "topo_waterarea-epsg31287-TMS",
        "http://wmsx.zamg.ac.at/mapcache201409/tms/",
        { layername: 'topo_waterarea@epsg31287', type: "jpg", serviceVersion:"1.0.0",
          gutter:0,buffer:0,isBaseLayer:true,transitionEffect:'resize',
          tileOrigin: new OpenLayers.LonLat(20085.090168,219828.777960),
          resolutions:[2000.0,1500.0,1400.0,1300.0,1200.0,1100.0,1000.0,886.0,800.0,700.0,600.0,500.0,450.0,400.0,350.0,300.0,250.0,200.0,150.0,100.0,50.0,25.0,10.0],
          zoomOffset:0,
          units:"m",
          maxExtent: new OpenLayers.Bounds(20085.090168,219828.777960,720025.090168,620300.777960),
          projection: new OpenLayers.Projection("EPSG:31287".toUpperCase()),
          sphericalMercator: false,
          visibility: true
        }
    );
    miniMap.addLayer(topo_waterarea_epsg31287_tms_layer);

/****
 * OVERLAYS OSM
 */

    var osm_overlay_epsg31287_tms_layer = new OpenLayers.Layer.TMS( "osm_overlay-epsg31287-TMS",
        "http://wmsx.zamg.ac.at/mapcache201409/tms/",
        { layername: 'osm_overlay@epsg31287', type: "png", serviceVersion:"1.0.0",
          gutter:0,buffer:0,transitionEffect:'resize',
          tileOrigin: new OpenLayers.LonLat(20085.090168,219828.777960),
          resolutions:[2000.0,1500.0,1400.0,1300.0,1200.0,1100.0,1000.0,886.0,800.0,700.0,600.0,500.0,450.0,400.0,350.0,300.0,250.0,200.0,150.0,100.0,50.0,25.0,10.0],
          zoomOffset:0,
          units:"m",
          maxExtent: new OpenLayers.Bounds(20085.090168,219828.777960,720025.090168,620300.777960),
          projection: new OpenLayers.Projection("EPSG:31287".toUpperCase()),
          sphericalMercator: false,
          visibility: true,
          isBaseLayer: false
        }
    );
    miniMap.addLayer(osm_overlay_epsg31287_tms_layer);


//- you can find the layer configuration for our
//   TMS service in the source code of the following
//   HTML page
//   http://wmsx.zamg.ac.at/mapcache201409.html
//   the two relevant layers are
//     + topo_waterarea@epsg31287 as BaseLayer and
//     + osm_overlay@epsg31287    as Overlay

            createViewport(miniMapDiv, extentBoxIds);
            addMapControls();
            miniMap.zoomToMaxExtent();

            Ext.EventManager.on(Ext.get(extentBoxIds.westBL),  'change', updateMap);
            Ext.EventManager.on(Ext.get(extentBoxIds.eastBL),  'change', updateMap);
            Ext.EventManager.on(Ext.get(extentBoxIds.southBL), 'change', updateMap);
            Ext.EventManager.on(Ext.get(extentBoxIds.northBL), 'change', updateMap);
        },

        /**
         * Clears the extent selection box
         */
        clearExtentBox: function() {
            clearExtentBox();
        },

        /**
         * Updates the extent selection box
         */
        updateExtentBox: function() {
            updateMap(true);
        },

        /**
         * Returns the map
         */
        getMap: function() {
            return miniMap;
        },
        
        synch: function(regionIndex, eBox) {
            $(regionControl).selectedIndex = regionIndex;
						if (eBox && extentBox) {
							extentBox.minxelement.set({value: eBox.minxelement.getValue()});
							extentBox.minyelement.set({value: eBox.minyelement.getValue()});
							extentBox.maxxelement.set({value: eBox.maxxelement.getValue()});
							extentBox.maxyelement.set({value: eBox.maxyelement.getValue()});
						}

            updateMap(false);
        },
        
        setSynchMinimap: function (minimap) {
            synchMinimaps.push(minimap); 
        },
        
        addWmsLayer: function(name, url, params, options) {
            createWmsLayer(name, url, params, options);
        }
        
    };
}; // end of app

GeoNetwork.minimapSimpleSearch = new GeoNetwork.miniapp();
GeoNetwork.minimapAdvancedSearch = new GeoNetwork.miniapp();
GeoNetwork.minimapRemoteSearch = new GeoNetwork.miniapp();

//Ext.onReady(GeoNetwork.miniapp.init, GeoNetwork.miniapp);
