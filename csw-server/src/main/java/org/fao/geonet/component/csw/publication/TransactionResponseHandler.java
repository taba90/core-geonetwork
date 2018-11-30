/*
 */
package org.fao.geonet.component.csw.publication;

import java.util.List;
import jeeves.server.context.ServiceContext;
import org.apache.commons.lang.StringUtils;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.csw.common.Csw;
import org.fao.geonet.csw.common.ElementSetName;
import org.fao.geonet.csw.common.ResultType;
import org.fao.geonet.csw.common.util.Xml;
import org.fao.geonet.kernel.SchemaManager;
import org.fao.geonet.utils.Log;
import org.jdom.Element;

/**
 * Handles the encoding of the TransactionResponse.
 *
 * Used by Transaction and Harvest operations.
 *
 * @author Emanuele Tajariol (etj at geo-solutions dot it)
 */
public class TransactionResponseHandler
{

    public static Element createResponse(ServiceContext context, List<InsertedMetadata> inserted,
                                   TransactionSummary summary, String requestId)
    {
        Element transactionResponse = new Element("TransactionResponse", Csw.NAMESPACE_CSW);

        // transactionSummary
        Element transactionSummary = summary.toXML();

        // requestID
        //String strRequestId = request.getAttributeValue("requestId");
        if (StringUtils.isNotBlank(requestId))
            transactionSummary.setAttribute("requestId", requestId);

        transactionResponse.addContent(transactionSummary);

        // Returns a "brief" view of any newly created catalogue records. The handle attribute may reference a
        // particular statement in the corresponding transaction request.
        if (summary.added > 0) {
            Element insertResult = new Element("InsertResult", Csw.NAMESPACE_CSW);
            insertResult.setAttribute("handleRef", "handleRefValue");

            SchemaManager schemaManager = context.getBean(SchemaManager.class);

            for (InsertedMetadata md : inserted) {
                Element briefRecord;

                try {
                    // apply CSW brief template
                    briefRecord = Xml.applyElementSetName(
                            context, schemaManager, md.schema, md.content,
                            "csw", ElementSetName.BRIEF, ResultType.RESULTS,
                            md.id, context.getLanguage());

                } catch(Exception e) {
                    // let's mock a BriefRecord, it's not complete, but it may be useful anyway
                    Log.warning(Geonet.CSW, "Error transforming metadata: " + md.id, e);

                    briefRecord = new Element("BriefRecord", Csw.NAMESPACE_CSW);
                    Element identifier = new Element("identifier", Csw.NAMESPACE_DC );
                    // TODO: title is mandatory
                    identifier.setText(md.id);
                    briefRecord.addContent(identifier);
                }
                insertResult.addContent(briefRecord);
            }

            transactionResponse.addContent(insertResult);
        }

        return transactionResponse;
    }

    public static class TransactionSummary {

        int added = 0;
        int updated = 0;
        int deleted = 0;


        public Element toXML() {

//            Element transactionResponse = new Element("TransactionResponse", Csw.NAMESPACE_CSW);
//            transactionResponse.addContent(transactionSummary);

            // Reports the total number of catalogue items modified by a transaction request (i.e, inserted, updated,
            // deleted). If the client did not specify a requestId, the server may assign one (a URI value).
            Element transactionSummary = new Element("TransactionSummary", Csw.NAMESPACE_CSW);
            if(added > 0)
                transactionSummary.addContent(new Element("totalInserted", Csw.NAMESPACE_CSW).setText(String.valueOf(added)));
            if(updated > 0)
                transactionSummary.addContent(new Element("totalUpdated", Csw.NAMESPACE_CSW).setText(String.valueOf(updated)));
            if(deleted > 0)
                transactionSummary.addContent(new Element("totalDeleted", Csw.NAMESPACE_CSW).setText(String.valueOf(deleted)));

            return transactionSummary;
        }

    }

    public static class InsertedMetadata{
        String schema;
        String id;
        Element content;

        public InsertedMetadata(String schema, String id, Element content) {
            this.schema = schema;
            this.id = id;
            this.content = content;
        }
    }

}
