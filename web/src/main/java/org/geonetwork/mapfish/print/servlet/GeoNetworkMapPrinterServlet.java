/*
 * Copyright (C) 2009  Camptocamp
 *
 * This file is part of MapFish Print
 *
 * MapFish Print is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MapFish Print is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MapFish Print.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.geonetwork.mapfish.print.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.mapfish.print.servlet.MapPrinterServlet;

/**
 * GeoNetwork main print servlet based on the mapfish one.
 * 
 * @author Tobia Di Pisa at tobia.dipisa@geo-solutions.it
 */
public class GeoNetworkMapPrinterServlet extends MapPrinterServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 3011384226606647774L;

	/**
     * Send an error XXX to the client with an exception
     */
    protected void error(HttpServletResponse httpServletResponse, Throwable e) {
        PrintWriter out = null;
        try {
            httpServletResponse.setContentType("text/plain");
            httpServletResponse.setStatus(500);
            out = httpServletResponse.getWriter();
            out.println("Error while generating PDF:");
            
//            e.printStackTrace(out);
            String message = e.getMessage();
//            message = URLEncoder.encode(message, "UTF-8");
            message = StringEscapeUtils.escapeHtml(message);
            out.println(message);

            LOGGER.error("Error while generating PDF", e);
        } catch (IOException ex) {
            throw new RuntimeException(e);
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

    /**
     * Send an error XXX to the client with a message
     */
    protected void error(HttpServletResponse httpServletResponse, String message, int code) {
        PrintWriter out = null;
        try {
            httpServletResponse.setContentType("text/plain");
            httpServletResponse.setStatus(code);
            out = httpServletResponse.getWriter();
            out.println("Error while generating PDF:");
            
//            message = URLEncoder.encode(message, "UTF-8");
            message = StringEscapeUtils.escapeHtml(message);
            out.println(message);

            LOGGER.error("Error while generating PDF: " + message);
        } catch (IOException ex) {
            throw new RuntimeException(ex);
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

}
