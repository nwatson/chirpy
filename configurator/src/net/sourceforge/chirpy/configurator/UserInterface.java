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

import java.lang.reflect.Constructor;

import net.sourceforge.chirpy.configurator.configuration.Model;

public abstract class UserInterface {
	public abstract void run (Model model);

	public static UserInterface factory () {
		String className = "ConsoleInterface";
		UserInterface ui = null;
		try {
			Class cls = Class.forName("net.sourceforge.chirpy.configurator.ui."
				+ className);
			Constructor constr = cls.getConstructor();
			ui = (UserInterface) constr.newInstance();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ui;
	}
}