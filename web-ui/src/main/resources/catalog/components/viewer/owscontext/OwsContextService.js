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
  goog.provide('gn_owscontext_service');







  goog.require('Filter_1_0_0');
  goog.require('GML_2_1_2');
  goog.require('OWC_0_3_1');
  goog.require('OWS_1_0_0');
  goog.require('SLD_1_0_0');
  goog.require('XLink_1_0');

  var module = angular.module('gn_owscontext_service', []);

  // OWC Client
  // Jsonix wrapper to read or write OWS Context
  var context = new Jsonix.Context(
      [XLink_1_0, OWS_1_0_0, Filter_1_0_0, GML_2_1_2, SLD_1_0_0, OWC_0_3_1],
      {
        namespacePrefixes: {
          'http://www.w3.org/1999/xlink': 'xlink',
          'http://www.opengis.net/ows': 'ows'
        }
      }
      );
  var unmarshaller = context.createUnmarshaller();
  var marshaller = context.createMarshaller();

  /**
   * @ngdoc service
   * @kind function
   * @name gn_viewer.service:gnOwsContextService
   * @requires gnMap
   * @requires gnOwsCapabilities
   * @requires gnEditor
   * @requires gnViewerSettings
   *
   * @description
   * The `gnOwsContextService` service provides tools to load and store OWS
   * Context.
   */
  module.service('gnOwsContextService', [
    'gnMap',
    'gnOwsCapabilities',
    '$http',
    'gnViewerSettings',
    '$translate',
    '$q',
    '$filter',
    '$rootScope',
    '$timeout',
    'gnGlobalSettings',
    function(gnMap, gnOwsCapabilities, $http, gnViewerSettings,
             $translate, $q, $filter, $rootScope, $timeout, gnGlobalSettings) {


      var firstLoad = true;

      /**
       * @ngdoc method
       * @name gnOwsContextService#loadContext
       * @methodOf gn_viewer.service:gnOwsContextService
       *
       * @description
       * Loads a context, ie. creates layers and centers the map
       *
       * @param {Object} context object
       */
      this.loadContext = function(text, map) {
        var context = unmarshaller.unmarshalString(text).value;
        // first remove any existing layer
        var layersToRemove = [];
        map.getLayers().forEach(function(layer) {
          if (layer.displayInLayerManager) {
            if (!(layer.get('fromUrlParams') && firstLoad)) {
              layersToRemove.push(layer);
            }
          }
        });
        for (var i = 0; i < layersToRemove.length; i++) {
          map.removeLayer(layersToRemove[i]);
        }

        // set the General.BoundingBox
        var bbox = context.general.boundingBox.value;
        var ll = bbox.lowerCorner;
        var ur = bbox.upperCorner;
        var projection = bbox.crs;

        //console.log("OwsContextService::loadContext: MAP  crs:" + map.getView().getProjection().getCode());
        //console.log("OwsContextService::loadContext: BBOX ll:"+ll+ " ur:"+ur + " crs:"+bbox.crs);

        if (projection == 'EPSG:4326') {
          ll.reverse();
          ur.reverse();
        }
        var extent = ll.concat(ur);
        // reproject in case bbox's projection doesn't match map's projection
        extent = ol.proj.transformExtent(extent,
            projection, map.getView().getProjection());

        extent = gnMap.secureExtent(extent, map.getView().getProjection());

        // store the extent into view settings so that it can be used later in
        // case the map is not visible yet
        gnViewerSettings.initialExtent = extent;

        // $timeout used to avoid map no rendered (eg: null size)
        $timeout(function() {
          map.getView().fit(extent, map.getSize(), { nearest: true });
        }, 0, false);

        // save this extent for later use (for example if the map
        // is not currently visible)
        map.set('lastExtent', extent);

        // load the resources
        var layers = context.resourceList.layer;
        var i, j, olLayer;
        var self = this;
        var promises = [];
        var overlays = [];
        if (angular.isArray(layers)) {

          // ----  Clean bg layers
          if (map.getLayers().getLength() > 0) {
            map.getLayers().removeAt(0);
          }
          if (!gnViewerSettings.bgLayers) {
            gnViewerSettings.bgLayers = [];
          }
          gnViewerSettings.bgLayers.length = 0;
          var bgLayers = gnViewerSettings.bgLayers;
          var isFirstBgLayer = false;
          // -------

          // FIRST LOOP: split bg and fg
          var existVisibileBg = false;
          var bglist  = [];
          var fglist  = [];

          for (i = 0; i < layers.length; i++) {
            var layer = layers[i];

            if (! layer.name) {
              console.warn("OwsContextService::loadContext: Placeholder: Skipping layer with no name");
              continue;
            }

            if (layer.group == 'Background layers') {
                bglist.push(layer);
                if(!layer.hidden) {
                    existVisibileBg = true;
                }

            } else {
                fglist.push(layer);
            }
          }

          // BG LOOP
          for (i = 0; i < bglist.length; i++) {
            var layer = bglist[i];

            console.log("OwsContextService::loadContext: BG Layer: " + layer.name + " LOOP: "+i);

            var type;
            var re = this.getREForPar('type');
            if (layer.name.match(re)) {
                type = re.exec(layer.name)[1];
            }

            var lname;
            re = this.getREForPar('name');
            if (layer.name.match(re)) {
                lname = re.exec(layer.name)[1];
            }

//            if (layer.group == 'Background layers') {

            // {type=bing_aerial} (mapquest, osm ...)
            if (type && type != 'wmts') {

              console.log("OwsContextService::loadContext: BG ["+type+"] Layer: " + layer.name);

              var opt;
              if (lname) {
                opt = {name: lname};
              }
              var olLayer = gnMap.createLayerForType(type, opt, layer.title);

              if (olLayer) {
                olLayer.displayInLayerManager = false;
                olLayer.background = true;
                olLayer.set('group', 'Background layers');
                olLayer.setVisible(!layer.hidden);

                bgLayers.push(olLayer);

                if ((!layer.hidden || !existVisibileBg) && !isFirstBgLayer ) {
                  olLayer.setVisible(true); // force if not exists other visibile BG layer
                  isFirstBgLayer = true;
                  map.getLayers().push(olLayer);
                }
              }
            } else { // {type=wmts,name=Ocean_Basemap} or WMS

              var placeHolderLayer = new ol.layer.Image({
                loading: true,
                label: 'loading ' + lname,
                url: '',
                visible: false
              });

              if ((!layer.hidden || !existVisibileBg) && !isFirstBgLayer ) {

                isFirstBgLayer = true;
                placeHolderLayer.set('bgLayer', true);

                var mapidx = map.getLayers().push(placeHolderLayer); // should be 1
                console.log("OwsContextService::loadContext: adding BG placeholder ["+type+"] map idx: "+mapidx+": " + layer.name);
              }

              var layerIndex = bgLayers.push(placeHolderLayer);
              console.log("OwsContextService::loadContext: adding BG placeholder ["+type+"] bg index: "+layerIndex+": " + layer.name);

              var p = self.createLayer(layer, map, i);

              (function(idx) {
                p.then(function(layer) {

                  console.log("OwsContextService::loadContext: old BG placeholder label: " + bgLayers[idx-1].get("label"));
                  bgLayers[idx-1] = layer;

                  if(!layer) {
                    console.log("OwsContextService::loadContext: ["+type+"] BG layer not created!");
                    return;
                  }

                  console.log("OwsContextService::loadContext: created ["+type+"] BG layer: " + layer.get('name'));

                  layer.displayInLayerManager = false;
                  layer.background = true;

                  if(placeHolderLayer.get('bgLayer')) {
                      console.log("OwsContextService::loadContext: replacing BG placeholder ["+type+"]: " + layer.name);
                      layer.setVisible(true); // force if not exists other visibile BG layer
                      console.log("OwsContextService::loadContext: replacing BG placeholder: OLD= " + map.getLayers().get(0).label );
                      map.getLayers().setAt(0, layer);
                  }

                });
              })(layerIndex);
            }
          } // END BG LOOP

          // FG LOOP
          for (i = 0; i < fglist.length; i++) {
            var layer = fglist[i];

            console.log("OwsContextService::loadContext: FG Layer: " + layer.name + " LOOP: "+i);

            if (! layer.server) {
                console.warn("OwsContextService::loadContext: missing server on FG Layer: " + layer.name);
                continue;
            }

            var type;
            var re = this.getREForPar('type');
            if (layer.name.match(re)) {
                type = re.exec(layer.name)[1];
            }

            var lname;
            re = this.getREForPar('name');
            if (layer.name.match(re)) {
                lname = re.exec(layer.name)[1];
            }

            var server = layer.server[0];
            if (server.service == 'urn:ogc:serviceType:WMS') {

              var placeHolderLayer = new ol.layer.Image({
                loading: true,
                label: 'loading',
                name: layer.name,
                url: '',
                visible: false
              });
              placeHolderLayer.displayInLayerManager = true;

//              console.info("OwsContextService::loadContext: loading layer " +  layer.name
//                      + " into map with " + map.getLayers().getLength() + " layers");

              var mapIdx = map.getLayers().push(placeHolderLayer);
              console.log("OwsContextService::loadContext: added FG placeholder ["+type+"] map index: "+mapIdx+": " + layer.name);

              var layerIdx = self.dumpMap(map, layer.name);

              var p = self.createLayer(layer, map, undefined, mapIdx);

              (function(idx) {
                p.then(function(layer) {
                    if(!layer) {
                        console.warn("OwsContextService::loadContext:then: null layer: " + idx);
                    }
//                  console.log("OwsContextService::loadContext: created ["+type+"] layer " + idx + ": " + self.stringify(layer));

                  var placeholder = map.getLayers().getArray()[idx];
                  console.log("OwsContextService::loadContext: replacing FG placeholder ["+type+"] "
                           + "index: "+idx
                           + " OLD:'"+placeholder.get('label')+"'"
                           + " NEW:'"+layer.get('name')+"'");
                  map.getLayers().setAt(idx, layer);

                  //console.log("OwsContextService::loadContext: CHECKPOINT2 " + layer.get('name'));

                });
              })(mapIdx);
            }

            firstLoad = false;
          }
        }
      };

    this.dumpMap = function (map, layername) {
        var layerIdx = -1;
        var larr = map.getLayers().getArray();
        for (lcnt = 0; lcnt < larr.length; lcnt++) {
            var ll = larr[lcnt];
            console.log("OwsContextService::loadContext: check: map["+lcnt+"] -> "
                    + "name:"+ll.get('name')
                    + " lbl:"+ll.get('label')
                    +"  ld:"+ll.get('loading'));
            if(layername &&  ll.get('name') == layername)
                layerIdx = lcnt;
        }
        console.log("OwsContextService::loadContext: found FG placeholder idx = "+layerIdx+" for layer " + layername);

        return layerIdx;
    }

    this.stringify = function (obj, replacer, spaces, cycleReplacer) {
      return JSON.stringify(obj, this.serializer(replacer, cycleReplacer), spaces)
    };

   this.serializer = function (replacer, cycleReplacer) {
        var stack = [], keys = []

       if (cycleReplacer == null) cycleReplacer = function(key, value) {
         if (stack[0] === value) return "[Circular ~]"
         return "[Circular ~." + keys.slice(0, stack.indexOf(value)).join(".") + "]"
       }

       return function(key, value) {
         if (stack.length > 0) {
           var thisPos = stack.indexOf(this)
           ~thisPos ? stack.splice(thisPos + 1) : stack.push(this)
           ~thisPos ? keys.splice(thisPos, Infinity, key) : keys.push(key)
           if (~stack.indexOf(value)) value = cycleReplacer.call(this, key, value)
         }
         else stack.push(value)

         return replacer == null ? value : replacer.call(this, key, value)
       }
     };

      /**
       * @ngdoc method
       * @name gnOwsContextService#loadContextFromUrl
       * @methodOf gn_viewer.service:gnOwsContextService
       *
       * @description
       * Loads a context from an URL.
       * @param {string} url URL to context
       * @param {ol.map} map map
       */
      this.loadContextFromUrl = function(url, map) {
        var self = this;
        //        if (/^(f|ht)tps?:\/\//i.test(url)) {
        //          url = gnGlobalSettings.proxyUrl + encodeURIComponent(url);
        //        }
        $http.get(url).success(function(data) {
          self.loadContext(data, map);
        });
      };

      /**
       * @ngdoc method
       * @name gnOwsContextService#writeContext
       * @methodOf gn_viewer.service:gnOwsContextService
       *
       * @description
       * Creates a javascript object based on map context then marshals it
       *    into XML
       * @param {ol.Map} context object
       */
      this.writeContext = function(map) {

        var extent = map.getView().calculateExtent(map.getSize());

        var general = {
          boundingBox: {
            name: {
              'namespaceURI': 'http://www.opengis.net/ows',
              'localPart': 'BoundingBox'
            },
            value: {
              crs: map.getView().getProjection().getCode(),
              lowerCorner: [extent[0], extent[1]],
              upperCorner: [extent[2], extent[3]]
            }
          }
        };

        var resourceList = {
          layer: []
        };

        // add the background layers
        // todo: grab this from config
        angular.forEach(gnViewerSettings.bgLayers, function(layer) {
          var source = layer.getSource();
          var name;
          var params = {
            hidden: map.getLayers().getArray().indexOf(layer) < 0,
            opacity: layer.getOpacity(),
            title: layer.get('title'),
            group: layer.get('group')
          };

          if (source instanceof ol.source.OSM) {
            name = '{type=osm}';
          } else if (source instanceof ol.source.MapQuest) {
            name = '{type=mapquest}';
          } else if (source instanceof ol.source.BingMaps) {
            name = '{type=bing_aerial}';
          } else if (source instanceof ol.source.Stamen) {
            name = '{type=stamen,name=' + layer.getSource().get('type') + '}';
          } else if (source instanceof ol.source.WMTS) {
            name = '{type=wmts,name=' + layer.get('name') + '}';
            params.server = [{
              onlineResource: [{
                href: layer.get('urlCap')
              }],
              service: 'urn:ogc:serviceType:WMS'
            }];
          } else if (source instanceof ol.source.ImageWMS) {
            var s = layer.getSource();
            name = s.getParams().LAYERS;
            params.server = [{
              onlineResource: [{
                href: s.getUrl()
              }],
              service: 'urn:ogc:serviceType:WMS'
            }];
          } else {
            return;
          }
          params.name = name;
          resourceList.layer.push(params);
        });

        map.getLayers().forEach(function(layer) {
          var source = layer.getSource();
          var url = '', version = null;
          var name;

          // background layers already taken into account
          if (layer.background) {
            return;
          }

          if (source instanceof ol.source.ImageWMS) {
            name = source.getParams().LAYERS;
            version = source.getParams().VERSION;
            url = source.getUrl();
          } else if (source instanceof ol.source.TileWMS ||
              source instanceof ol.source.ImageWMS) {
            name = source.getParams().LAYERS;
            url = layer.get('url');
          } else if (source instanceof ol.source.WMTS) {
            name = '{type=wmts,name=' + layer.get('name') + '}';
            url = layer.get('urlCap');
          }
          var layerParams = {
            hidden: !layer.getVisible(),
            opacity: layer.getOpacity(),
            name: name,
            title: layer.get('title'),
            group: layer.get('group'),
            groupcombo: layer.get('groupcombo'),
            server: [{
              onlineResource: [{
                href: url
              }],
              service: 'urn:ogc:serviceType:WMS'
            }]
          };
          if (version) {
            layerParams.server[0].version = version;
          }
          resourceList.layer.push(layerParams);
        });

        var context = {
          version: '0.3.1',
          id: 'ows-context-ex-1-v3',
          general: general,
          resourceList: resourceList
        };

        var xml = marshaller.marshalDocument({
          name: {
            localPart: 'OWSContext',
            namespaceURI: 'http://www.opengis.net/ows-context',
            prefix: 'ows-context',
            string: '{http://www.opengis.net/ows-context}ows-context:OWSContext'
          },
          value: context
        });
        return xml;
      };

      /**
       * @ngdoc method
       * @name gnOwsContextService#writeContext
       * @methodOf gn_viewer.service:gnOwsContextService
       *
       * @description
       * Saves the map context to local storage
       *
       * @param {ol.Map} map object
       */
      this.saveToLocalStorage = function(map) {
        var storage = gnViewerSettings.storage ?
            window[gnViewerSettings.storage] : window.localStorage;
        if (map.getSize()[0] == 0 || map.getSize()[1] == 0) {
          // don't save a map which has not been rendered yet
          return;
        }
        var xml = this.writeContext(map);
        var xmlString = (new XMLSerializer()).serializeToString(xml);
        var key = 'owsContext_' +
            window.location.host + window.location.pathname;
        storage.setItem(key, xmlString);
      };

      /**
       * @ngdoc method
       * @name gnOwsContextService#createLayer
       * @methodOf gn_viewer.service:gnOwsContextService
       *
       * @description
       * Create a WMS ol.Layer from context object
       *
       * @param {Object} layer layer
       * @param {ol.map} map map
       * @param {numeric} bgIdx if it is a background layer, index in the
       * dropdown
       * @param {numeric} index of the layer in the tree
       */
      this.createLayer = function(layer, map, bgIdx, index) {

        var server = layer.server[0];
        var res = server.onlineResource[0];
        var reT = /type\s*=\s*([^,|^}|^\s]*)/;
        var reL = /name\s*=\s*([^,|^}|^\s]*)/;

        var createOnly = angular.isDefined(bgIdx) || angular.isDefined(index);

        if (layer.name.match(reT)) {
          var type = reT.exec(layer.name)[1];
          var name = reL.exec(layer.name)[1];

          console.log("OwsContextService::createLayer: Layer: " + name + " type: "+ type);

          if (type == 'wmts') {
            //console.log("OwsContextService::createLayer: creating WMTS layer " + name);
            return gnMap.addWmtsFromScratch(map, res.href, name, createOnly).
                then(function(olL) {
                  if(!olL) {
                    console.warn("OwsContextService::createLayer::then: created null WMTS layer " + layer.name);
                  }

                  //console.log("OwsContextService::createLayer::thenWMTS: created ["+type+"] layer " + olL.get("name"));
                  olL.set('group', layer.group);
                  olL.set('groupcombo', layer.groupcombo);
                  olL.setOpacity(layer.opacity);
                  olL.setVisible(!layer.hidden);
                  if (layer.title) {
                    olL.set('title', layer.title);
                    olL.set('label', layer.title);
                  }
                  if (bgIdx) {
                    olL.set('bgIdx', bgIdx);
                  } else if (index) {
                    olL.set('tree_index', index);
                  }
                  return olL;
                }).catch(function() {
                  console.warn("OwsContextService::createLayer::catch: error creating WMTS layer");
                });
          }
        }
        else { // we suppose it's WMS
          // TODO: Would be good to attach the MD
          // even when loaded from a context.
          return gnMap.addWmsFromScratch(
              map, res.href, layer.name,
              createOnly, null, server.version).
              then(function(olL) {
                if (olL) {
                  //console.log("OwsContextService::createLayer::thenOther: created ["+type+"] layer " + layer.name);
                  try {
                    // Avoid double encoding
                    if (layer.group) {
                      layer.group = decodeURIComponent(escape(layer.group));
                    }
                  } catch (e) {}
                  olL.set('group', layer.group);
                  olL.set('groupcombo', layer.groupcombo);
                  olL.set('tree_index', index);
                  olL.setOpacity(layer.opacity);
                  olL.setVisible(!layer.hidden);
                  if (layer.title) {
                    olL.set('title', layer.title);
                    olL.set('label', layer.title);
                  }
                  $rootScope.$broadcast('layerAddedFromContext', olL);
                  return olL;
                }
                return olL;
              }).catch(function() {
                  console.warn("OwsContextService::createLayer::catch: error creating ["+type+"] layer");
              });
        }
      };

      /**
       * @ngdoc method
       * @name gnOwsContextService#getREForPar
       * @methodOf gn_viewer.service:gnOwsContextService
       *
       * @description
       * Creates a regular expression for a given parameter
       *
       * * @param {Object} context parameter
       */
      this.getREForPar = function(par) {
        return re = new RegExp(par + '\\s*=\\s*([^,|^}|^\\s]*)');
      };

    }
  ]);
})();
