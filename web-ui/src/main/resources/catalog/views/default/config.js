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

        var layers = [
            new ol.layer.Tile({source:topo_base_wmts}),
            new ol.layer.Tile({source:dach_overlay_wmts})
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
            view: new ol.View({
                extent: [107778.5323, 286080.6331, 694883.9348, 575953.6150],
                center: ol.proj.transform([14.149161, 47.510335], 'EPSG:4326', 'EPSG:31287'),
                projection: ol.proj.get("EPSG:31287"),
                minZoom: 3
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
