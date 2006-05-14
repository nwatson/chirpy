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

public class ModelParameter {
	public enum Type { STRING, INTEGER, BOOLEAN }

	private String name;

	private Type type;

	private String description;

	private Object defaultValue;

	public ModelParameter (String name, Type type) {
		this.name = name;
		this.type = type;
	}

	public ModelParameter (String name, String type) throws Exception {
		this(name, parseType(type));
	}

	public String getName () {
		return name;
	}

	public String getDescription () {
		return description;
	}

	public Object getDefaultValue () {
		return defaultValue;
	}

	public Type getType () {
		return type;
	}

	public void setDescription (String description) {
		this.description = description;
	}

	public void setDefaultValue (Object defaultValue) {
		this.defaultValue = defaultValue;
	}

	public static Type parseType (String type) throws Exception {
		if (type.equals("string")) {
			return Type.STRING;
		}
		if (type.equals("int")) {
			return Type.INTEGER;
		}
		if (type.equals("boolean")) {
			return Type.BOOLEAN;
		}
		throw new Exception("Unknown type: \"" + type + "\"");
	}
}
