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
        function(searchSettings, viewerSettings, gnOwsContextService, gnMap) {
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

          /*******************************************************************
             * Define maps
             */
          // define Austria Lambert projection (EPSG:31287) since it seems not supported in this ngeo/ol3 relase
          proj4.defs("EPSG:31287","+proj=lcc +lat_1=49 +lat_2=46 +lat_0=47.5 +lon_0=13.33333333333333 +x_0=400000 +y_0=400000 +ellps=bessel +towgs84=577.326,90.129,463.919,5.137,1.474,5.297,2.4232 +units=m +no_defs");
          ol.proj.get("EPSG:31287").setExtent([107778.5323, 286080.6331, 694883.9348, 575953.6150]);
          ol.proj.get("EPSG:31287").setWorldExtent([9.5300, 46.4100, 17.1700, 49.0200]);

          // tile grid info here: http://wmsx.zamg.ac.at/mapcache201409/tms/1.0.0
          var tileGrid = new ol.tilegrid.TileGrid({
              extent: [20085.090168,219828.777960,720025.090168,620300.777960],
              origin: [20085.090168,219828.777960],
              resolutions:[1500.0,1400.0,1300.0,1200.0,1100.0,1000.0,886.0,800.0,700.0,600.0,500.0,450.0,400.0,350.0,300.0,250.0,200.0,150.0,100.0,50.0,25.0,10.0],
              tileSize:[512,512]
          });
          var url_topo_waterarea = "http://wmsx.zamg.ac.at/mapcache201409/tms/1.0.0/topo_waterarea@epsg31287/{z}/{x}/{y}.jpg";
          var url2_osm_overlay = "http://wmsx.zamg.ac.at/mapcache201409/tms/1.0.0/osm_overlay@epsg31287/{z}/{x}/{y}.png";
          // we can't use the url with pattern {-y} (http://openlayers.org/en/v3.14.2/apidoc/ol.source.XYZ.html) 
          // because seems that this ngeo/ol3 version has a bug about it.
          // we set the origin properly in the tile grid and define a custom tileUrlFunction
          var layers = [
               new ol.layer.Tile({
                   source: new ol.source.XYZ({
                       tileGrid: tileGrid,
                       tileUrlFunction: function(tileCoord, pixelRatio, projection) {
                         return url_topo_waterarea.replace('{z}',tileCoord[0]).replace('{x}',tileCoord[1]).replace('{y}',tileCoord[2]);
                       }
                   })
               }),
               new ol.layer.Tile({
                     source: new ol.source.XYZ({
                         tileGrid: tileGrid,
                         tileUrlFunction: function(tileCoord, pixelRatio, projection) {
                           return url2_osm_overlay.replace('{z}',tileCoord[0]).replace('{x}',tileCoord[1]).replace('{y}',tileCoord[2]);
                         }
                     })
                 })
             ]
          var viewerMap = new ol.Map({
            controls: [],
            layers: layers,
            view: new ol.View({
              extent: [20085.090168,219828.777960,720025.090168,620300.777960],
              center: ol.proj.transform([14.149161, 47.510335], 'EPSG:4326', 'EPSG:31287'),
              projection: ol.proj.get("EPSG:31287"),
              minZoom: 1
            })
          });

          var searchMap = new ol.Map({
            controls:[],
            layers: layers,
            view: new ol.View({
              extent: [347778.5323, 566080.6331, 504883.9348, 505953.6150],
              center: ol.proj.transform([14.149161, 47.510335], 'EPSG:4326', 'EPSG:31287'),
              projection: ol.proj.get("EPSG:31287")
            })
          });


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
            defaultUrl: 'md.format.xml?xsl=xsl-view&uuid=',
            defaultPdfUrl: 'md.format.pdf?xsl=full_view&uuid=',
            list: [{
            //  label: 'inspire',
            //  url: 'md.format.xml?xsl=xsl-view' + '&view=inspire&id='
            //}, {
            //  label: 'full',
            //  url: 'md.format.xml?xsl=xsl-view&view=advanced&id='
            //}, {
              label: 'full',
              url: 'md.format.xml?xsl=full_view&uuid='
              /*
              // You can use a function to choose formatter
              url : function(md) {
                return 'md.format.xml?xsl=full_view&uuid=' + md.getUuid();
              }*/
            }]
          };

          // Mapping for md links in search result list.
          searchSettings.linkTypes = {
            links: ['LINK'],
            downloads: ['DOWNLOAD'],
            layers:['OGC', 'kml'],
            maps: ['ows']
          };

          // Set the default template to use
          searchSettings.resultTemplate =
              searchSettings.resultViewTpls[0].tplUrl;

          // Set custom config in gnSearchSettings
          angular.extend(searchSettings, {
            viewerMap: viewerMap,
            searchMap: searchMap
          });
        }]);
})();
