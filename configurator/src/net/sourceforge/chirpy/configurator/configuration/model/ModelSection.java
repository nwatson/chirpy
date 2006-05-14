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

package net.sourceforge.chirpy.configurator.configuration.model;

import java.util.ArrayList;
import java.util.List;

public class ModelSection {
	private String name;

	private ModelSection parent;

	private String description;

	private List<ModelSection> sections;

	private List<ModelParameter> parameters;

	public ModelSection (String name, ModelSection parent) {
		this.name = name;
		this.parent = parent;
		sections = new ArrayList<ModelSection>();
		parameters = new ArrayList<ModelParameter>();
	}

	public String getName () {
		return name;
	}

	public String getDescription () {
		return description;
	}

	public ModelSection getParentSection () {
		return parent;
	}

	public List<ModelSection> getSections () {
		return sections;
	}

	public List<ModelParameter> getParameters () {
		return parameters;
	}

	public void setDescription (String description) {
		this.description = description;
	}

	public void addSection (ModelSection section) {
		sections.add(section);
	}

	public void addParameter (ModelParameter parameter) {
		parameters.add(parameter);
	}
}
