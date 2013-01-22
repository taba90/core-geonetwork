//=============================================================================
//==============================================================================

package org.fao.geonet.services.csi;


import jeeves.constants.Jeeves;
import jeeves.exceptions.BadParameterEx;
import jeeves.exceptions.MissingParameterEx;
import jeeves.interfaces.Service;
import jeeves.resources.dbms.Dbms;
import jeeves.server.ServiceConfig;
import jeeves.server.context.ServiceContext;
import jeeves.utils.Util;
import org.fao.geonet.constants.Geonet;
import org.jdom.Element;

//=============================================================================

/** 
  */

public class GetComuniByProv implements Service
{
	private ServiceConfig _config;

	//--------------------------------------------------------------------------
	//---
	//--- Init
	//---
	//--------------------------------------------------------------------------

	public void init(String appPath, ServiceConfig config) throws Exception
	{
		_config = config;
	}

	//--------------------------------------------------------------------------
	//---
	//--- Service
	//---
	//--------------------------------------------------------------------------

	public Element exec(Element params, ServiceContext context) throws Exception
	{
//		GeonetContext gc = (GeonetContext) context.getHandlerContext(Geonet.CONTEXT_NAME);

		String provId      = params.getChildText("provId");
		String provCode    = params.getChildText("provCode");
		String provName    = params.getChildText("provName");

        if(provId == null && provCode == null && provName == null)
            throw new MissingParameterEx("provId or provCode or provName", params);

        Dbms dbms = (Dbms) context.getResourceManager().open (Geonet.Res.MAIN_DB);

        Element response;
        if(provId != null) {
            int id;
            try {
                 id = Integer.parseInt(provId);
            } catch (NumberFormatException e) {
                throw new BadParameterEx("provId", provId);
            }
            response = dbms.select("select c.* from comuni c, province p where p.id=? and p.code=c.provCode order by c.label", id);
        } else if (provCode != null) {
            response = dbms.select("select * from comuni where provCode=? order by label", provCode);
        } else if (provName != null) {
            response = dbms.select("select c.* from comuni c, province p where p.label=? and p.code=c.provCode order by c.label", provName);
        } else {
            throw new IllegalStateException();
        }

		response.setName(Jeeves.Elem.RESPONSE);
        return response;
	}
}

//=============================================================================

