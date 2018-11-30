/*
 */
package org.fao.geonet.component.csw.publication;

import com.google.common.base.Function;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import jeeves.server.context.ServiceContext;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpRequestRetryHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.fao.geonet.Constants;
import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.kernel.setting.SettingManager;
import org.fao.geonet.kernel.setting.Settings;
import org.fao.geonet.lib.Lib;
import org.fao.geonet.util.MailSender;
import org.fao.geonet.utils.GeonetHttpRequestFactory;
import org.fao.geonet.utils.Log;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.springframework.http.HttpStatus;
import org.springframework.http.client.ClientHttpResponse;

/**
 * Sends asyncronous responses to remote handlers.
 *
 *
 * @author refactored by Emanuele Tajariol (etj at geo-solutions dot it)
 */
public class HarvestResponseSender
{
    /**
     * Supported protocols for ResponseHandlers.
     */
    public static enum Protocol {
        /**
         * File Transfer Protocol.
         */
        FTP {
            public String toString() {
                return "ftp://";
            }
        },
        /**
         * Hypertext Transfer Protocol.
         */
        HTTP {
            public String toString() {
                return "http://";
            }
        },
        /**
         * Electronic mail.
         */
        EMAIL {
            public String toString() {
                return "mailto:";
            }
        };

        /**
         * Returns the enum value that has a toString starting with the requested string, or null if
         * not found.
         *
         * @param string - string to match
         * @return matching protocol or null if not found
         */
        public static Protocol validate(String string) {
            if (StringUtils.isNotEmpty(string)) {
                for (Protocol protocol : Protocol.values()) {
                    if (string.startsWith(protocol.toString())) {
                        return protocol;
                    }
                }
            }
            return null;
        }
    }

    private Protocol protocol;
    private String responseHandler;

    ServiceContext serviceContext;

    public HarvestResponseSender(String responseHandler, ServiceContext serviceContext) {

        this.responseHandler = responseHandler;
        this.protocol = Protocol.validate(responseHandler);
        this.serviceContext = serviceContext;

        if(! isSupported(responseHandler))
            throw new ExceptionInInitializerError("WARNING: unsupported protocol in responseHandler " + responseHandler + ", failed to create HarvestResponseSender");
    }

    public static boolean isSupported(String responseHandler) {
        return Protocol.validate(responseHandler) != null;
    }

    /**
     * Sends Harvest response using email.
     *
     * @param harvestResponse response to send
     */
    private void sendByEmail(String harvestResponse) {
        GeonetContext geonetContext = (GeonetContext) serviceContext.getHandlerContext(Geonet.CONTEXT_NAME);
        SettingManager settingManager = geonetContext.getBean(SettingManager.class);
        String host = settingManager.getValue(Settings.SYSTEM_FEEDBACK_MAILSERVER_HOST);
        String port = settingManager.getValue(Settings.SYSTEM_FEEDBACK_MAILSERVER_PORT);
        String to = responseHandler.substring(Protocol.EMAIL.toString().length());
        MailSender sender = new MailSender(serviceContext);
        sender.send(host, Integer.parseInt(port), settingManager.getValue(Settings.SYSTEM_FEEDBACK_MAILSERVER_USERNAME), settingManager.getValue(Settings.SYSTEM_FEEDBACK_MAILSERVER_PASSWORD), settingManager.getValueAsBool(Settings.SYSTEM_FEEDBACK_MAILSERVER_SSL), settingManager.getValueAsBool(Settings.SYSTEM_FEEDBACK_MAILSERVER_TLS), settingManager.getValueAsBool(Settings.SYSTEM_FEEDBACK_MAILSERVER_IGNORE_SSL_CERTIFICATE_ERRORS), settingManager.getValue(Settings.SYSTEM_FEEDBACK_EMAIL), "GeoNetwork CSW Server", to, null, "Asynchronous CSW Harvest results delivery", harvestResponse);
    }

    /**
     * Sends Harvest response using FTP.
     *
     * @param harvestResponse response to send
     */
    private void sendByFTP(String harvestResponse) {
        FTPClient ftpClient = null;
        try {
            ftpClient = new FTPClient();
            // parse ftp uri
            URI ftpUri = new URI(responseHandler);
            String host = ftpUri.getHost();
            int port = ftpUri.getPort();
            String path = ftpUri.getPath();
            String userInfo = ftpUri.getUserInfo();
            String user = null;
            String password = null;
            if (StringUtils.isNotEmpty(userInfo)) {
                user = userInfo.substring(0, userInfo.indexOf(':'));
                password = userInfo.substring(userInfo.indexOf(':') + 1);
            }
            if (port > 0) {
                ftpClient.connect(host, port);
            } else {
                ftpClient.connect(host);
            }
            if (Log.isDebugEnabled(Geonet.CSW_HARVEST)) {
                Log.debug(Geonet.CSW_HARVEST, "Connected to " + host + ".");
            }
            if (Log.isDebugEnabled(Geonet.CSW_HARVEST)) {
                Log.debug(Geonet.CSW_HARVEST, ftpClient.getReplyString());
            }
            // check if connection is OK
            int reply = ftpClient.getReplyCode();
            if (!FTPReply.isPositiveCompletion(reply)) {
                ftpClient.disconnect();
                Log.warning(Geonet.CSW_HARVEST, "Warning: FTP server refused connection. Not sending asynchronous CSW Harvest results to " + responseHandler);
                return;
            }
            // set timeout to 5 minutes
            ftpClient.setControlKeepAliveTimeout(300);
            // login
            if (user != null && password != null) {
                ftpClient.login(user, password);
            } else {
                ftpClient.login("anonymous", "");
            }
            // cd to directory
            if (StringUtils.isNotEmpty(path)) {
                ftpClient.changeWorkingDirectory(path);
            }
            //
            // transfer file
            //
            String filename = "CSW.Harvest.result";
            InputStream is = new ByteArrayInputStream(harvestResponse.getBytes(Constants.ENCODING));
            ftpClient.storeFile(filename, is);
            is.close();
            ftpClient.logout();
        } // never mind, just log it
        catch (IOException x) {
            System.err.println("WARNING: " + x.getMessage() + " (this exception is swallowed)");
            x.printStackTrace();
        } // never mind, just log it
        catch (URISyntaxException x) {
            System.err.println("WARNING: " + x.getMessage() + " (this exception is swallowed)");
            x.printStackTrace();
        } finally {
            if (ftpClient != null && ftpClient.isConnected()) {
                try {
                    ftpClient.disconnect();
                } // never mind, just log it
                catch (IOException x) {
                    System.err.println("WARNING: " + x.getMessage() + " (this exception is swallowed)");
                    x.printStackTrace();
                }
            }
        }
    }

    /**
     * Sends Harvest response using HTTP POST.
     *
     * @param harvestResponse response to send
     */
    private void sendByHTTP(String harvestResponse) {
        HttpPost method = new HttpPost(responseHandler);
        try {
            RequestConfig.Builder config = RequestConfig.custom();
            method.setEntity(new StringEntity(harvestResponse));
            config.setAuthenticationEnabled(false);
            method.setConfig(config.build());
            final String requestHost = method.getURI().getHost();
            final ClientHttpResponse httpResponse = serviceContext.getBean(GeonetHttpRequestFactory.class).execute(method, new Function<HttpClientBuilder, Void>() {
                @Nullable
                @Override
                public Void apply(@Nonnull HttpClientBuilder input) {
                    SettingManager settingManager = serviceContext.getBean(SettingManager.class);
                    Lib.net.setupProxy(settingManager, input, requestHost);
                    input.setRetryHandler(new DefaultHttpRequestRetryHandler());
                    return null;
                }
            });
            if (httpResponse.getStatusCode() != HttpStatus.OK) {
                // never mind, just log it
                Log.warning(Geonet.CSW_HARVEST, "WARNING: Failed to send HarvestResponse to responseHandler " + responseHandler + ", HTTP status is " + httpResponse.getStatusText());
            }
        } catch (IOException x) {
            // never mind, just log it
            Log.warning(Geonet.CSW_HARVEST, "WARNING: " + x.getMessage() + " (this exception is swallowed)");
            x.printStackTrace();
        } finally {
            method.releaseConnection();
        }
    }

    /**
     * Sends a HarvestResponse to the destination specified in responseHandler.
     *
     * Supports http, email and ftp.
     * <p>
     * OGC 07-006 10.12.5: .. send it to the URI specified by the ResponseHandler parameter
     * using the protocol encoded therein. Common protocols are ftp for sending the response to
     * a ftp server and mailto which may be used to send the response to an email address.
     *
     * @param harvestResponse - the response to send
     */
    public void send(Element harvestResponse) {
        if (Log.isDebugEnabled(Geonet.CSW_HARVEST)) {
            Log.debug(Geonet.CSW_HARVEST, "AsyncHarvestResponse send started");
        }
        String harvestResponseString = Xml.getString(harvestResponse);
        if (Log.isDebugEnabled(Geonet.CSW_HARVEST)) {
            Log.debug(Geonet.CSW_HARVEST, "Sending HarvestResponse to " + responseHandler);
        }
        switch (protocol) {
            case EMAIL:
                sendByEmail(harvestResponseString);
                break;
            case FTP:
                sendByFTP(harvestResponseString);
                break;
            case HTTP:
                sendByHTTP(harvestResponseString);
                break;
            default:
                // shouldn't happen
                Log.warning(Geonet.CSW_HARVEST, "WARNING: unsupported protocol for responseHandler " + responseHandler + ". " + "HarvestResponse is not sent.");
        }
        if (Log.isDebugEnabled(Geonet.CSW_HARVEST)) {
            Log.debug(Geonet.CSW_HARVEST, "AsyncHarvestResponse send finished");
        }
    }

}
