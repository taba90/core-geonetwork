/*
 * Copyright (C) 2001-2020 Food and Agriculture Organization of the
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

package org.fao.geonet.utils;

import org.apache.jcs.JCS;
import org.apache.log4j.AppenderSkeleton;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.spi.LoggingEvent;
import org.fao.geonet.JeevesJCS;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.w3c.dom.ls.LSInput;

import java.net.URISyntaxException;
import java.nio.file.Paths;

import static org.junit.Assert.*;

public class XmlResolverTest {

    XmlResolver xmlResolver;

    @Before
    public void setUp () throws URISyntaxException {
        String path = Paths.get(XmlTest.class.getResource("oasis-catalog-test.xml").toURI()).toString();
        xmlResolver = new XmlResolver(new String []{path}, new ProxyInfo().getProxyParams());
        JeevesJCS.setConfigFilename(Paths.get(getClass().getResource("xmltest/mock-cache.ccf").toURI()));
    }

    @Test
    public void tryResolveOnFsTestWithExternalResource() throws URISyntaxException {
        // testing that when an external resource is at stake,
        // the tryResolveOnFs method doesn't throws and exception trying
        // to resolve the url on local path, but skip it logging a warn message.
        String path = XmlTest.class.getResource("xmltest/xml.xsd").toURI().toString();
        String type = "http://www.w3.org/2001/XMLSchema";
        String namespace = "http://purl.org/dc/elements/1.1/";
        String onlineXsd = "http://www.w3.org/2001/03/xml.xsd";
        LSInput result = xmlResolver.resolveResource(type, namespace, null, onlineXsd, path);
        assertNotNull(result);
        String data = result.getStringData();
        assertNotNull(data);
        assertFalse(data.equals(""));

    }

    @After
    public void clean (){
        JeevesJCS.setConfigFilename(null);
    }

}
