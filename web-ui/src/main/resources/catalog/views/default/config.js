/*
 * Copyright (C) 2001-2016 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */

(function() {

  goog.provide('gn_search_default_config');

  var module = angular.module('gn_search_default_config', []);

  module.value('gnTplResultlistLinksbtn',
      '../../catalog/views/default/directives/partials/linksbtn.html');

  module
      .run([
        'gnSearchSettings',
        'gnViewerSettings',
        'gnOwsContextService',
        'gnMap',
        'gnNcWms',
        'gnConfig',
        function(searchSettings, viewerSettings, gnOwsContextService,
                 gnMap, gnNcWms, gnConfig) {
          // Load the context defined in the configuration
          viewerSettings.defaultContext =
            viewerSettings.mapConfig.viewerMap ||
            '../../map/config-viewer.xml';

          // Keep one layer in the background
          // while the context is not yet loaded.
          viewerSettings.bgLayers = [
            gnMap.createLayerForType('osm')
          ];

          viewerSettings.servicesUrl =
            viewerSettings.mapConfig.listOfServices || {};

          // WMS settings
          // If 3D mode is activated, single tile WMS mode is
          // not supported by ol3cesium, so force tiling.
          if (gnConfig['map.is3DModeAllowed']) {
            viewerSettings.singleTileWMS = false;
            // Configure Cesium to use a proxy. This is required when
            // WMS does not have CORS headers. BTW, proxy will slow
            // down rendering.
            viewerSettings.cesiumProxy = true;
          } else {
            viewerSettings.singleTileWMS = true;
          }

          var bboxStyle = new ol.style.Style({
            stroke: new ol.style.Stroke({
              color: 'rgba(255,0,0,1)',
              width: 2
            }),
            fill: new ol.style.Fill({
              color: 'rgba(255,0,0,0.3)'
            })
          });
          searchSettings.olStyles = {
            drawBbox: bboxStyle,
            mdExtent: new ol.style.Style({
              stroke: new ol.style.Stroke({
                color: 'orange',
                width: 2
              })
            }),
            mdExtentHighlight: new ol.style.Style({
              stroke: new ol.style.Stroke({
                color: 'orange',
                width: 3
              }),
              fill: new ol.style.Fill({
                color: 'rgba(255,255,0,0.3)'
              })
            })

          };

          // Display related links in grid ?
          searchSettings.gridRelated = ['parent', 'children',
            'services', 'datasets'];

          // Object to store the current Map context
          viewerSettings.storage = 'sessionStorage';

          /*******************************************************************
           * Define maps
           */

        // define Austria Lambert projection (EPSG:31287) since it seems not supported in this ngeo/ol3 relase
        proj4.defs("EPSG:31287","+proj=lcc +lat_1=49 +lat_2=46 +lat_0=47.5 +lon_0=13.33333333333333 +x_0=400000 +y_0=400000 +ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs +axis=neu");
//        ol.proj.get("EPSG:31287").setExtent([107778.5323, 286080.6331, 694883.9348, 575953.6150]); // this is the real extent
        ol.proj.get("EPSG:31287").setExtent([80000.00, 286080.6331, 694883.9348, 600000.0]);         // extent used to show the whole Austrian region
//        ol.proj.get("EPSG:31287").setWorldExtent([9.5300, 46.4100, 17.1700, 59.0200]);
        ol.proj.get("EPSG:31287").setWorldExtent([-180.0, 0.0, 180.0, 90.0]);

        var matrixIds = [];
        for (var i = 0; i <= 13; ++i) {
            matrixIds[i] = i;
        }

        var projectionExtent = ol.proj.get('EPSG:31287').getExtent();

        var topo_base_wmts = new ol.source.WMTS({
            attributions: "Topo Grau",
            url: "http://wmsx.zamg.ac.at/mapcacheStatmap/wmts/1.0.0/grey/default/statmap/{TileMatrix}/{TileRow}/{TileCol}.png",
            requestEncoding: "REST",
            layer: "grey",
            matrixSet: "statmap",
            format: "image/png",
            style: "default",
            isBaseLayer: true,

            projection: ol.proj.get("EPSG:31287"),

            tileGrid: new ol.tilegrid.WMTS({
                extent: projectionExtent,
                origin: [-2000000.000000, 3200000.000000],
                resolutions: [8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1],
                matrixIds: matrixIds,
                tileSize: [512, 512]
            })
        });

        var dach_overlay_wmts = new ol.source.WMTS({
            attributions: "Overlay all",
            url: "http://wmsx.zamg.ac.at/mapcacheStatmap/wmts/1.0.0/overlay-all/default/statmap/{TileMatrix}/{TileRow}/{TileCol}.png",
            requestEncoding: "REST",
            layer: "overlay-all",
            matrixSet: "statmap",
            format: "image/png",
            style: "default",
            visibility: true,
            isBaseLayer: false,
            projection: ol.proj.get("EPSG:31287"),
            tileGrid: new ol.tilegrid.WMTS({
                extent: projectionExtent,
                origin: [-2000000.000000, 3200000.000000],
                resolutions: [8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1],
                matrixIds: matrixIds,
                tileSize: [512, 512]
            })
        });


        var topo_base_tile = new ol.layer.Tile({source:topo_base_wmts});
        var overlay_tile   = new ol.layer.Tile({source:dach_overlay_wmts});

        [topo_base_tile, overlay_tile].forEach(function(layer, index) {
            layer.displayInLayerManager = true;
            layer.background = true;
            layer.set('group', 'Background layers');
            layer.setVisible(true);
        });

        // viewerSettings.bgLayers = [topo_base_tile];

        var layers= [
                topo_base_tile,
                overlay_tile
        ];

        var searchMap = new ol.Map({
            controls: [],
            layers: layers,
            view: new ol.View({
                extent: [107778.5323, 286080.6331, 694883.9348, 575953.6150],
                center: ol.proj.transform([14.149161, 47.510335], 'EPSG:4326', 'EPSG:31287'),
                projection: ol.proj.get("EPSG:31287")
            })
        });

        // no layers for the viewermap: it's controlled by the OwsContextService
        var viewerMap = new ol.Map({
            controls: [],
            // layers: [], // temporary init
            view: new ol.View({
                extent: [107778.5323, 286080.6331, 694883.9348, 575953.6150],
                center: ol.proj.transform([14.149161, 47.510335], 'EPSG:4326', 'EPSG:31287'),
                projection: ol.proj.get("EPSG:31287"),
                minZoom: 3
            })
        });

/*
          var mapsConfig = {
            center: [280274.03240585705, 6053178.654789996],
            zoom: 2
            //maxResolution: 9783.93962050256
          };

          var viewerMap = new ol.Map({
            controls: [],
            view: new ol.View(mapsConfig)
          });

          var searchMap = new ol.Map({
            controls:[],
            layers: [new ol.layer.Tile({
              source: new ol.source.OSM()
            })],
            view: new ol.View(angular.extend({}, mapsConfig))
          });
*/

          /** Facets configuration */
          searchSettings.facetsSummaryType = 'details';

          /*
             * Hits per page combo values configuration. The first one is the
             * default.
             */
          searchSettings.hitsperpageValues = [20, 50, 100];

          /* Pagination configuration */
          searchSettings.paginationInfo = {
            hitsPerPage: searchSettings.hitsperpageValues[0]
          };

          /*
             * Sort by combo values configuration. The first one is the default.
             */
          searchSettings.sortbyValues = [{
            sortBy: 'relevance',
            sortOrder: ''
          }, {
            sortBy: 'changeDate',
            sortOrder: ''
          }, {
            sortBy: 'title',
            sortOrder: 'reverse'
          }, {
            sortBy: 'rating',
            sortOrder: ''
          }, {
            sortBy: 'popularity',
            sortOrder: ''
          }, {
            sortBy: 'denominatorDesc',
            sortOrder: ''
          }, {
            sortBy: 'denominatorAsc',
            sortOrder: 'reverse'
          }];

          /* Default search by option */
          searchSettings.sortbyDefault = searchSettings.sortbyValues[0];

          /* Custom templates for search result views */
          searchSettings.resultViewTpls = [{
                  tplUrl: '../../catalog/components/search/resultsview/' +
                  'partials/viewtemplates/grid.html',
                  tooltip: 'Grid',
                  icon: 'fa-th'
                }];

          // For the time being metadata rendering is done
          // using Angular template. Formatter could be used
          // to render other layout

          // TODO: formatter should be defined per schema
          // schema: {
          // iso19139: 'md.format.xml?xsl=full_view&&id='
          // }
          searchSettings.formatter = {
            // defaultUrl: 'md.format.xml?xsl=full_view&id='
            // defaultUrl: 'md.format.xml?xsl=xsl-view&uuid=',
            // defaultPdfUrl: 'md.format.pdf?xsl=full_view&uuid=',
            list: [{
              label: 'full',
              url : function(md) {
                return '../api/records/' + md.getUuid() + '/formatters/xsl-view?root=div&view=advanced';
              }
            }]
          };

          // Mapping for md links in search result list.
          searchSettings.linkTypes = {
            links: ['LINK', 'kml'],
            downloads: ['DOWNLOAD'],
            //layers:['OGC', 'kml'],
            layers:['OGC'],
            maps: ['ows']
          };

          // Map protocols used to load layers/services in the map viewer
          searchSettings.mapProtocols = {
            layers: [
              'OGC:WMS',
              'OGC:WMS-1.1.1-http-get-map',
              'OGC:WMS-1.3.0-http-get-map',
              'OGC:WFS'
              ],
            services: [
              'OGC:WMS-1.3.0-http-get-capabilities',
              'OGC:WMS-1.1.1-http-get-capabilities',
              'OGC:WFS-1.0.0-http-get-capabilities'
              ]
          };

          // Set the default template to use
          searchSettings.resultTemplate =
              searchSettings.resultViewTpls[0].tplUrl;

          // Set custom config in gnSearchSettings
          angular.extend(searchSettings, {
            viewerMap: viewerMap,
            searchMap: searchMap
          });

          viewerMap.getLayers().on('add', function(e) {
            var layer = e.element;
            if (layer.get('advanced')) {
              gnNcWms.feedOlLayer(layer);
            }
          });

        }]);
})();
