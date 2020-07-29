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

package org.fao.geonet.component.csw;

import jeeves.server.context.ServiceContext;
import org.fao.geonet.AbstractCoreIntegrationTest;
import org.fao.geonet.Assert;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.csw.common.Csw;
import org.fao.geonet.csw.common.exceptions.InvalidParameterValueEx;
import org.fao.geonet.kernel.GeonetworkDataDirectory;
import org.fao.geonet.kernel.mef.MEFLibIntegrationTest;
import org.fao.geonet.utils.Xml;
import org.jdom.Comment;
import org.jdom.Element;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

import static junit.framework.TestCase.assertEquals;
import static junit.framework.TestCase.assertTrue;

/**
 * Test CSW Search Service.
 * <p/>
 * Created by Jesse on 1/27/14.
 */
@ContextConfiguration(inheritLocations = true, locations = "classpath:csw-integration-test-context.xml")
public class CswGetRecords_Test extends AbstractCoreIntegrationTest {

    private static final String field = "title";

    @Autowired
    private GetRecords _getRecords;

    @Test
    public void test_IsEqualIsNotEqualTo() throws Exception {
        final ServiceContext serviceContext = createServiceContext();
        serviceContext.setLanguage(null);
        loginAsAdmin(serviceContext);
        final MEFLibIntegrationTest.ImportMetadata importMetadata = new MEFLibIntegrationTest.ImportMetadata(this, serviceContext);
        importMetadata.getMefFilesToLoad().add("mef2-example-2md.zip");
        importMetadata.invoke();
        final String keyword = "Photographs";
//        final String keyword = "AWRD";

        Element request = new Element("GetRecords", Csw.NAMESPACE_CSW)
            .setAttribute("service", "CSW")
            .setAttribute("version", "2.0.2")
            .setAttribute("resultType", "results")
            .setAttribute("startPosition", "1")
            .setAttribute("maxRecords", "50")
            .setAttribute("outputSchema", "csw:Record")
            .addContent(new Element("Query", Csw.NAMESPACE_CSW)
                .addContent(new Element("ElementSetName", Csw.NAMESPACE_CSW).setText("summary"))
            );

        Element result = _getRecords.execute(request, serviceContext);

        final String xpath = "*//csw:SummaryRecord/dc:title";
        List<Element> nodes = (List<Element>) Xml.selectNodes(result, xpath, Arrays.asList(Csw.NAMESPACE_CSW, Csw.NAMESPACE_DC));
//        for (int i = 0; i < nodes.size(); i++) {
//            System.out.println(nodes.get(i).getText());
//        }
        Assert.assertEquals(3, nodes.size());
        nodes.clear();

        Element filter = new Element("PropertyIsEqualTo", Csw.NAMESPACE_OGC)
            .addContent(new Element("PropertyName",
                Csw.NAMESPACE_OGC).setText(field))
            .addContent(new Element("Literal",
                Csw.NAMESPACE_OGC).setText(keyword));


        request = new Element("GetRecords", Csw.NAMESPACE_CSW)
            .setAttribute("service", "CSW")
            .setAttribute("version", "2.0.2")
            .setAttribute("resultType", "results")
            .setAttribute("startPosition", "1")
            .setAttribute("maxRecords", "50")
            .setAttribute("outputSchema", "csw:Record")
            .addContent(new Element("Query", Csw.NAMESPACE_CSW)
                .addContent(new Element("ElementSetName", Csw.NAMESPACE_CSW).setText("summary"))
                .addContent(
                    new Element("Constraint", Csw.NAMESPACE_CSW)
                        .setAttribute("version", "1.0.0")
                        .addContent(
                            new Element("Filter", Csw.NAMESPACE_OGC)
                                .addContent(filter)
                        )
                )
            );

        result = _getRecords.execute(request, serviceContext);

        nodes = (List<Element>) Xml.selectNodes(result, xpath, Arrays.asList(Csw.NAMESPACE_CSW, Csw.NAMESPACE_DC));
//        for (int i = 0; i < nodes.size(); i++) {
//            System.out.println(nodes.get(i).getText());
//        }
        Assert.assertEquals(1, nodes.size());
        nodes.clear();

        filter = new Element("PropertyIsNotEqualTo", Csw.NAMESPACE_OGC)
            .addContent(new Element("PropertyName",
                Csw.NAMESPACE_OGC).setText(field))
            .addContent(new Element("Literal",
                Csw.NAMESPACE_OGC).setText(keyword));


        request = new Element("GetRecords", Csw.NAMESPACE_CSW)
            .setAttribute("service", "CSW")
            .setAttribute("version", "2.0.2")
            .setAttribute("resultType", "results")
            .setAttribute("startPosition", "1")
            .setAttribute("maxRecords", "50")
            .setAttribute("outputSchema", "csw:Record")
            .addContent(new Element("Query", Csw.NAMESPACE_CSW)
                .addContent(new Element("ElementSetName", Csw.NAMESPACE_CSW).setText("summary"))
                .addContent(
                    new Element("Constraint", Csw.NAMESPACE_CSW)
                        .setAttribute("version", "1.0.0")
                        .addContent(
                            new Element("Filter", Csw.NAMESPACE_OGC)
                                .addContent(filter)
                        )
                )
            );

        result = _getRecords.execute(request, serviceContext);
        nodes = (List<Element>) Xml.selectNodes(result, xpath, Arrays.asList(Csw.NAMESPACE_CSW, Csw.NAMESPACE_DC));
//        for (int i = 0; i < nodes.size(); i++) {
//            System.out.println(nodes.get(i).getText());
//        }
        Assert.assertEquals(2, nodes.size());



        // Check that exception returned if startPos greater than matching records

        request = new Element("GetRecords", Csw.NAMESPACE_CSW)
            .setAttribute("service", "CSW")
            .setAttribute("version", "2.0.2")
            .setAttribute("resultType", "results")
            .setAttribute("startPosition", "4")
            .setAttribute("maxRecords", "1")
            .setAttribute("outputSchema", "csw:Record")
            .addContent(new Element("Query", Csw.NAMESPACE_CSW)
                .addContent(new Element("ElementSetName", Csw.NAMESPACE_CSW).setText("summary"))
            );
        try {
            result = _getRecords.execute(request, serviceContext);
        } catch (InvalidParameterValueEx ex) {
            Assert.assertTrue(true);
        }


        // Check that next record is 2 for first record
        request = new Element("GetRecords", Csw.NAMESPACE_CSW)
            .setAttribute("service", "CSW")
            .setAttribute("version", "2.0.2")
            .setAttribute("resultType", "results")
            .setAttribute("startPosition", "1")
            .setAttribute("maxRecords", "1")
            .setAttribute("outputSchema", "csw:Record")
            .addContent(new Element("Query", Csw.NAMESPACE_CSW)
                .addContent(new Element("ElementSetName", Csw.NAMESPACE_CSW).setText("summary"))
            );
        result = _getRecords.execute(request, serviceContext);
        String nextRecord = result.getChild("SearchResults", Csw.NAMESPACE_CSW).getAttributeValue("nextRecord");
        Assert.assertEquals("2", nextRecord);



        // Check that next record is 0 at then of the list
        request = new Element("GetRecords", Csw.NAMESPACE_CSW)
            .setAttribute("service", "CSW")
            .setAttribute("version", "2.0.2")
            .setAttribute("resultType", "results")
            .setAttribute("startPosition", "3")
            .setAttribute("maxRecords", "1")
            .setAttribute("outputSchema", "csw:Record")
            .addContent(new Element("Query", Csw.NAMESPACE_CSW)
                .addContent(new Element("ElementSetName", Csw.NAMESPACE_CSW).setText("summary"))
            );
        result = _getRecords.execute(request, serviceContext);
        nextRecord = result.getChild("SearchResults", Csw.NAMESPACE_CSW).getAttributeValue("nextRecord");
        Assert.assertEquals("0", nextRecord);
    }

    @Test
    public void testPreProcessingXsl() throws Exception {

        final ServiceContext serviceContext = loadMetadataForXslTests();

        Element request = new Element("GetRecords", Csw.NAMESPACE_CSW)
            .setAttribute("service", "CSW")
            .setAttribute("version", "2.0.2")
            .setAttribute("resultType", "results")
            .setAttribute("startPosition", "1")
            .setAttribute("maxRecords", "50")
            .setAttribute("outputSchema", "csw:Record")
            .addContent(new Element("Query", Csw.NAMESPACE_CSW)
                .addContent(new Element("ElementSetName", Csw.NAMESPACE_CSW).setText("summary"))
            )
            .addContent(new Element(Geonet.Elem.FILTER).setText("+_schema:iso19139"))
            .addContent(new Element(Geonet.Elem.STYLESHEET).setText("test-virtual-csw.xsl"));

        Element result = _getRecords.execute(request, serviceContext);

        final String xpath = "*//csw:SummaryRecord/dc:identifier";
        List<Element> nodes = (List<Element>) Xml.selectNodes(result, xpath, Arrays.asList(Csw.NAMESPACE_CSW, Csw.NAMESPACE_DC));
        // size should be three since dublin-core metadata has been filtered out
        assertEquals(3, nodes.size());
        for (int i = 0; i < nodes.size(); i++) {
            assertTrue(nodes.get(i).getText().startsWith("aStringToTestVirtualCswStylesheet."));
        }
    }


    @Test
    public void testPreProcessingNotExistingXsl() throws Exception {
        final ServiceContext serviceContext = loadMetadataForXslTests();

        Element request = new Element("GetRecords", Csw.NAMESPACE_CSW)
            .setAttribute("service", "CSW")
            .setAttribute("version", "2.0.2")
            .setAttribute("resultType", "results")
            .setAttribute("startPosition", "1")
            .setAttribute("maxRecords", "50")
            .setAttribute("outputSchema", "csw:Record")
            .addContent(new Element("Query", Csw.NAMESPACE_CSW)
                .addContent(new Element("ElementSetName", Csw.NAMESPACE_CSW).setText("summary"))
            )
            .addContent(new Element(Geonet.Elem.FILTER).setText("+_schema:iso19139"))
            .addContent(new Element(Geonet.Elem.STYLESHEET).setText("not-existing.xsl"));

        Element result = _getRecords.execute(request, serviceContext);

        final String xpath = ".[1]/csw:SearchResults";
        List<Comment> nodes = (List<Comment>) ((Element) Xml.selectNodes(result, xpath, Arrays.asList(Csw.NAMESPACE_CSW, Csw.NAMESPACE_DC)).get(0)).getContent();
        for (Comment c : nodes) {
            assertTrue(c.getText()
                .contains("The stylesheet selected at /data/config/schema_plugins/iso19139/present/csw/virtual/not-existing.xsl doesn't exist"));
        }
    }

    private ServiceContext loadMetadataForXslTests() throws Exception {
        ServiceContext serviceContext = createServiceContext();
        loginAsAdmin(serviceContext);
        final MEFLibIntegrationTest.ImportMetadata importMetadata = new MEFLibIntegrationTest.ImportMetadata(this, serviceContext);
        //iso19139 3 metadata
        importMetadata.getMefFilesToLoad().add("mef2-example-2md.zip");
        // add 1 metadata dublin-core also to test schema filtering
        importMetadata.getMefFilesToLoad().add("dublin-core.mef");
        importMetadata.invoke();
        serviceContext.setLanguage(null);
        return serviceContext;
    }

    @Override
    protected void addTestSpecificData(GeonetworkDataDirectory geonetworkDataDirectory) throws IOException {
        try {
            Path csw = geonetworkDataDirectory.getSchemaPluginsDir().resolve("iso19139").resolve("present").resolve("csw");
            Path pathToXsl = Paths.get(getClass().getResource("virtual").toURI());
            org.fao.geonet.utils.IO.copyDirectoryOrFile(pathToXsl, csw, true);
        } catch (URISyntaxException e) {
            throw new IOException(e);
        }
    }

}
