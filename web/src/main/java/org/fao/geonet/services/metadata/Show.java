//=============================================================================
//===	Copyright (C) 2001-2007 Food and Agriculture Organization of the
//===	United Nations (FAO-UN), United Nations World Food Programme (WFP)
//===	and United Nations Environment Programme (UNEP)
//===
//===	This program is free software; you can redistribute it and/or modify
//===	it under the terms of the GNU General Public License as published by
//===	the Free Software Foundation; either version 2 of the License, or (at
//===	your option) any later version.
//===
//===	This program is distributed in the hope that it will be useful, but
//===	WITHOUT ANY WARRANTY; without even the implied warranty of
//===	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//===	General Public License for more details.
//===
//===	You should have received a copy of the GNU General Public License
//===	along with this program; if not, write to the Free Software
//===	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
//===
//===	Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
//===	Rome - Italy. email: geonetwork@osgeo.org
//==============================================================================

package org.fao.geonet.services.metadata;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jeeves.exceptions.NotFoundEx;
import jeeves.exceptions.ResourceNotFoundEx;
import jeeves.interfaces.Service;
import jeeves.resources.dbms.Dbms;
import jeeves.server.ServiceConfig;
import jeeves.server.UserSession;
import jeeves.server.context.ServiceContext;
import jeeves.utils.Util;
import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.constants.Params;
import org.fao.geonet.exceptions.MetadataNotFoundEx;
import org.fao.geonet.kernel.AccessManager;
import org.fao.geonet.kernel.DataManager;
import org.fao.geonet.kernel.MdInfo;
import org.fao.geonet.kernel.SchemaManager;
import org.fao.geonet.kernel.XmlSerializer;
import org.fao.geonet.lib.Lib;
import org.fao.geonet.services.Utils;
import org.jdom.Attribute;
import org.jdom.Element;

import jeeves.utils.Xml;

//=============================================================================

/** Retrieves a particular metadata. Access is restricted
  */

public class Show implements Service
{
    private String appPath;

	//--------------------------------------------------------------------------
	//---
	//--- Init
	//---
	//--------------------------------------------------------------------------

	public void init(String appPath, ServiceConfig params) throws Exception
	{
        this.appPath = appPath;

		String skip;
		
		skip = params.getValue("skipPopularity", "n");
		skipPopularity = skip.equals("y");

		skip = params.getValue("skipInfo", "n");
		skipInfo = skip.equals("y");

		skip = params.getValue("addRefs", "n");
		addRefs = skip.equals("y");
		
		cache = "y".equalsIgnoreCase(params.getValue("cache", "n"));
	}

	//--------------------------------------------------------------------------
	//---
	//--- Service
	//---
	//--------------------------------------------------------------------------

	public Element exec(Element params, ServiceContext context) throws Exception
	{
		UserSession session = context.getUserSession();

		//-----------------------------------------------------------------------
		//--- handle current tab

		Element elCurrTab = params.getChild(Params.CURRTAB);
		boolean removeSchemaLocation = Util.getParam(params, "removeSchemaLocation", "false").equals("true");

		if (elCurrTab != null)
			session.setProperty(Geonet.Session.METADATA_SHOW, elCurrTab.getText());

		//-----------------------------------------------------------------------
		//--- check access

		GeonetContext gc = (GeonetContext) context.getHandlerContext(Geonet.CONTEXT_NAME);
		DataManager   dm = gc.getDataManager();
		SchemaManager sm = gc.getSchemamanager();

		String id = Utils.getIdentifierFromParameters(params, context);
		boolean skipPopularity = this.skipPopularity;
		if (!skipPopularity) { // skipPopularity could be a URL param as well
			String skip = Util.getParam(params, "skipPopularity", "n");
			skipPopularity = skip.equals("y");
		}
		
		boolean witholdWithheldElements = Util.getParam(params, "hide_withheld", false);
		if (XmlSerializer.getThreadLocal(false) != null || witholdWithheldElements) {
		   XmlSerializer.getThreadLocal(true).setForceHideWithheld(witholdWithheldElements);
		}
		if (id == null)
			throw new MetadataNotFoundEx("Metadata not found.");
		
		Lib.resource.checkPrivilege(context, id, AccessManager.OPER_VIEW);

		//-----------------------------------------------------------------------
		//--- get metadata
		
		Element elMd;
		boolean addEditing = false;
		if (!skipInfo) {
            boolean withValidationErrors = false, keepXlinkAttributes = false;
            elMd = gc.getDataManager().getMetadata(context, id, addEditing, withValidationErrors, keepXlinkAttributes);
		}
        else {
			elMd = dm.getMetadataNoInfo(context, id);
		}

		if (elMd == null) throw new MetadataNotFoundEx(id);

		if (addRefs) { // metadata.show for GeoNetwork needs geonet:element 
			elMd = dm.enumerateTree(elMd);
		}

		//
		// setting schemaLocation - if there isn't one then use the schemaLocation 
		// that is in the GeoNetwork schema identification and if there isn't one 
		// of those then build one pointing to the XSD in GeoNetwork 

		Dbms dbms = (Dbms) context.getResourceManager().open(Geonet.Res.MAIN_DB);
		MdInfo mdInfo = dm.getMetadataInfo(dbms, id);
		Attribute schemaLocAtt = sm.getSchemaLocation(mdInfo.schemaId, context);
		if (schemaLocAtt != null) {
			if (elMd.getAttribute(schemaLocAtt.getName(), schemaLocAtt.getNamespace()) == null) {
				elMd.setAttribute(schemaLocAtt);
				// make sure namespace declaration for schemalocation is present -
				// remove it first (does nothing if not there) then add it
				elMd.removeNamespaceDeclaration(schemaLocAtt.getNamespace()); 
				elMd.addNamespaceDeclaration(schemaLocAtt.getNamespace());
			}
		}

		//--- increase metadata popularity
		if (!skipPopularity)
			dm.increasePopularity(context, id);

        // process metadata if requested
		String process = Util.getParam(params, Params.PROCESS, null);
        if(process != null) {
			elMd = process(dm, dbms, id, process, context, params, elMd);
        }
		
		if(cache) {
		    cache(context.getUserSession(), elMd, id);
		}
		if (removeSchemaLocation) {
		    elMd.removeAttribute("schemaLocation", Xml.xsiNS);
		}
		return elMd;
	}

	private final static String KEY = "SHOW_METADATA";
    private static void cache( UserSession userSession, Element elMd, String id ) {
        userSession.setProperty(KEY+id, elMd);
    }
    
    public static Element getCached(UserSession userSession, String id) {
        return (Element) userSession.getProperty(KEY+id);
    }

    static void unCache(UserSession userSession, String id) {
        userSession.removeProperty(KEY+id);
    }

    //--------------------------------------------------------------------------
	//---
	//--- Variables
	//---
	//--------------------------------------------------------------------------

	private boolean skipPopularity;
	private boolean skipInfo;
	private boolean addRefs;
    private boolean cache;
    
    protected Element process(DataManager dm, Dbms dbms, String id, String process, ServiceContext context, Element params, Element metadata) throws ResourceNotFoundEx, Exception {
        // --- check processing exist for current schema
        String schema = dm.getMetadataSchema(dbms, id);
        String filePath = appPath + "WEB-INF/data/config/schema_plugins/" + schema + "/process/"
                + process + ".xsl";
        File xslProcessing = new File(filePath);
        if (!xslProcessing.exists()) {
            context.info("  Processing instruction not found for " + schema
                    + " schema.");
            throw new ResourceNotFoundEx(process);
        }
        // collect query params should be needed in the transformation
        Map<String, String> xslParams = new HashMap<String, String>();
        for (Element param : (List<Element>)params.getChildren()) {
            xslParams.put(param.getName(), param.getTextTrim());
        }

        return Xml.transform(metadata, filePath, xslParams);
    }
    
}
//=============================================================================

