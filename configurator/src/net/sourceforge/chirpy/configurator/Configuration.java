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

package net.sourceforge.chirpy.configurator;

import java.io.IOException;
import java.io.PrintWriter;

import java.util.ArrayList;
import java.util.List;

import net.sourceforge.chirpy.configurator.configuration.Section;
import net.sourceforge.chirpy.configurator.configuration.Parameter;

public class Configuration {
	private List<Section> sections;
	
	public Configuration () {
		sections = new ArrayList<Section>();
	}

	public List<Section> getSections () {
		return sections;
	}

	public void addSection (Section section) {
		sections.add(section);
	}
	
	public void write (String fileName) throws IOException {
		PrintWriter out = new PrintWriter(fileName);
		for (Section section : getSections()) {
			dumpSection(section, null, out);
			for (Section subsection : section.getSections()) {
				dumpSection(subsection, section, out);
			}
			out.println();
		}
		out.close();
	}

	private static void dumpSection (Section section, Section parent,
		PrintWriter out) {
		String prefix;
		if (parent == null) {
			prefix = "";
			out.println("[" + section.getName() + "]");
		}
		else {
			prefix = parent.getName() + ".";
		}
		for (Parameter parameter : section.getParameters()) {
			out.println(prefix + parameter.getName() + "="
				+ parameter.getValue());
		}
	}
}
