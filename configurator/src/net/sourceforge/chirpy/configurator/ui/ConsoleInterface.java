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

package net.sourceforge.chirpy.configurator.ui;

import java.io.File;
import java.util.List;
import java.util.Scanner;

import net.sourceforge.chirpy.configurator.Configuration;
import net.sourceforge.chirpy.configurator.UserInterface;
import net.sourceforge.chirpy.configurator.configuration.Model;
import net.sourceforge.chirpy.configurator.configuration.Parameter;
import net.sourceforge.chirpy.configurator.configuration.Section;
import net.sourceforge.chirpy.configurator.configuration.model.ModelParameter;
import net.sourceforge.chirpy.configurator.configuration.model.ModelSection;

public class ConsoleInterface extends UserInterface {
	private final static Scanner SCANNER = new Scanner(System.in);

public void run (Model model) {
		List<ModelSection> sections = model.getSections();
		Configuration configuration = new Configuration();
		for (ModelSection section : sections) {
			Section cSection = parseSection(section);
			configuration.addSection(cSection);
		}
		while (true) {
			System.out.print("Save As [chirpy.ini]: ");
			String path = SCANNER.nextLine();
			if (path.length() == 0) {
				path = "chirpy.ini";
			}
			File file = new File(path);
			if (file.exists()) {
				if (file.isDirectory()) {
					System.out.println("Sorry, \"" + file.getAbsolutePath()
						+ "\" is a directory");
					System.out.println();
					continue;
				}
				else {
					boolean answered = false;
					boolean overwrite = false;
					while (!answered) {
						System.out.println("Overwrite existing \""
							+ file.getAbsolutePath() + "\"? [y/N]");
						String answer = SCANNER.nextLine();
						if (answer.length() == 0) {
							answered = true;
						}
						else {
							char first = answer.charAt(0);
							if (first == 'Y' || first == 'y') {
								answered = true;
								overwrite = true;
							}
							else if (first == 'N' || first == 'n') {
								answered = true;
							}
						}
					}
					if (!overwrite) {
						continue;
					}
				}
			}
			System.out.print("Attempting to write to \"" + path + "\" ... ");
			if (write(configuration, path)) {
				break;
			}
		}
		System.out.println("Done");
	}	private static boolean write (Configuration configuration, String path) {
		try {
			configuration.write(path);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	private static Section parseSection (ModelSection section) {
		Section cSection = new Section(section.getName());
		ModelSection parentSection = section.getParentSection();
		String fullName;
		if (parentSection != null) {
			fullName = parentSection.getName() + "." + section.getName();
		}
		else {
			fullName = section.getName();
		}
		announceSection(fullName, section.getDescription());
		for (ModelParameter parameter : section.getParameters()) {
			Parameter cParameter = parseParameter(parameter, fullName);
			if (cParameter != null) {
				cSection.addParameter(cParameter);
			}
		}
		for (ModelSection subsection : section.getSections()) {
			Section cSubsection = parseSection(subsection);
			cSection.addSection(cSubsection);
		}
		return cSection;
	}

	private static Parameter parseParameter (ModelParameter parameter,
		String sectionTitle) {
		String name = parameter.getName();
		Object value = requestValue(sectionTitle + "." + parameter.getName(),
			parameter.getDescription(), parameter.getDefaultValue(), parameter
				.getType());
		if (value == null) {
			return null;
		}
		Parameter cParameter = new Parameter(name, value);
		return cParameter;
	}

	private static void announceSection (String name, String description) {
		System.out.println(name);
		for (int i = 0; i < name.length(); i++) {
			System.out.print("=");
		}
		System.out.println();
		System.out.println();
		showDescription(description, "");
		System.out.println();
	}

	private static Object requestValue (String name, String description,
		Object defaultValue, ModelParameter.Type type) {
		String title = name + " (" + type + ")";
		System.out.println(title);
		for (int i = 0; i < title.length(); i++) {
			System.out.print("-");
		}
		System.out.println();
		System.out.println();
		showDescription(description, "  ");
		Object value;
		while (true) {
			System.out.print("  Value ["
				+ (defaultValue != null ? defaultValue : "") + "]: ");
			String input = SCANNER.nextLine();
			if (input.length() == 0) {
				value = defaultValue;
				break;
			}
			else if (type.equals(ModelParameter.Type.BOOLEAN)) {
				if (input.equalsIgnoreCase("true")) {
					value = true;
					break;
				}
				else if (input.equalsIgnoreCase("false")) {
					value = false;
					break;
				}
			}
			else if (type.equals(ModelParameter.Type.INTEGER)) {
				value = tryToParseInt(input);
				if (value != null) {
					break;
				}
			}
		}
		System.out.println();
		System.out.println();
		return value;
	}

	private static Integer tryToParseInt (String input) {
		try {
			return Integer.parseInt(input);
		} catch (Exception e) {}
		return null;
	}

	private static void showDescription (String description, String prefix) {
		if (description == null) {
			return;
		}
		StringBuffer output = new StringBuffer();
		String[] words = description.split(" ");
		for (String word : words) {
			int newLength = prefix.length() + output.length() + word.length()
				+ 1;
			if (newLength > 78) {
				System.out.println(prefix + output);
				output = new StringBuffer(word);
			}
			else {
				output.append(output.length() > 0 ? " " + word : word);
			}
		}
		System.out.println(prefix + output);
		System.out.println();
	}
}
