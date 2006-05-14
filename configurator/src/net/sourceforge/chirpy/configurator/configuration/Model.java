/*
 * ****************************************************************************
 * ChirpyConfigurator! v0.3, a configuration tool for Chirpy!
 * Copyright (C) 2005-2006 Tim De Pauw <ceetee@users.sourceforge.net>
 * ****************************************************************************
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc., 51
 * Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 * ****************************************************************************
 */

package net.sourceforge.chirpy.configurator.configuration;

import java.io.CharArrayWriter;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import net.sourceforge.chirpy.configurator.configuration.model.ModelParameter;
import net.sourceforge.chirpy.configurator.configuration.model.ModelSection;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class Model extends DefaultHandler {
	public static final String SYNTAX_FILE_NAME = "chirpy.ini.xml";

	private static Model instance;

	private List<ModelSection> sections;

	private CharArrayWriter chars;

	private ModelSection currentSection;

	private ModelParameter currentParameter;

	protected Model () {
		sections = new ArrayList<ModelSection>();
		SAXParserFactory factory = SAXParserFactory.newInstance();
		try {
			SAXParser saxParser = factory.newSAXParser();
			saxParser.parse(new File(SYNTAX_FILE_NAME), this);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<ModelSection> getSections () {
		return sections;
	}

	public void startElement (String namespaceURI, String lName, String qName,
		Attributes attrs) throws SAXException {
		chars = new CharArrayWriter();
		if (qName.equals("Section")) {
			currentSection = new ModelSection(attrs.getValue("name"),
				currentSection);
		}
		else if (qName.equals("Parameter")) {
			try {
				currentParameter = new ModelParameter(attrs.getValue("name"),
					attrs.getValue("type"));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public void endElement (String namespaceURI, String sName, String qName)
		throws SAXException {
		if (qName.equals("Section")) {
			ModelSection parent = currentSection.getParentSection();
			if (parent == null) {
				sections.add(currentSection);
			}
			else {
				parent.addSection(currentSection);
			}
			currentSection = parent;
		}
		else if (qName.equals("Parameter")) {
			currentSection.addParameter(currentParameter);
			currentParameter = null;
		}
		else if (qName.equals("Description")) {
			String desc = chars.toString().replaceAll("\\s+", " ");
			if (currentParameter != null) {
				currentParameter.setDescription(desc);
			}
			else {
				currentSection.setDescription(desc);
			}
		}
		else if (qName.equals("DefaultValue")) {
			String defaultAsString = chars.toString();
			Object defaultValue = null;
			if (currentParameter.getType().equals(ModelParameter.Type.BOOLEAN)) {
				defaultValue = defaultAsString.equalsIgnoreCase("true");
			}
			else if (currentParameter.getType().equals(ModelParameter.Type.INTEGER)) {
				try {
					defaultValue = Integer.parseInt(defaultAsString);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (currentParameter.getType().equals(ModelParameter.Type.STRING)) {
				defaultValue = defaultAsString;
			}
			currentParameter.setDefaultValue(defaultValue);
		}
	}

	public void characters (char buf[], int offset, int len)
		throws SAXException {
		chars.write(buf, offset, len);
	}

	public static Model getInstance () {
		if (instance == null) {
			instance = new Model();
		}
		return instance;
	}
}
