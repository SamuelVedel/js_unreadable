package fr.svedel.unreadable;

import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {
	
	public static String replaceNewName(String sourceCode, int nNameFounded, Pattern patt,
										int scope) {
		Matcher match = patt.matcher(sourceCode);
		int i = 0;
		while (match.find()) {
			if (i >= nNameFounded) {
				int start = match.start("name");
				String name = match.group("name");
				NameToReplace ntp = new NameToReplace(name, start, sourceCode);
				return ntp.replace();
			}
			++i;
		}
		return null;
	}
	
	public static String replaceNewName(String sourceCode, int nNameFounded, Pattern patt) {
		return replaceNewName(sourceCode, nNameFounded, patt, NameToReplace.VARIABLE_SCOPE);
	}
	
	public static String replaceAllName(String sourceCode, Pattern patt, int scope) {
		int nNameFounded = 0;
		String newCode = replaceNewName(sourceCode, nNameFounded, patt, scope);
		while (newCode != null) {
			sourceCode = newCode;
			newCode = replaceNewName(sourceCode, nNameFounded, patt, scope);
			++nNameFounded;
		}
		return sourceCode;
	}
	
	public static String replaceAllName(String sourceCode, Pattern patt) {
		return replaceAllName(sourceCode, patt, NameToReplace.VARIABLE_SCOPE);
	}
	
	// ---- fonctions pour le remplacement des arguments
	
	public static String replaceNewArgs(String sourceCode, int nNameFounded, Pattern patt) {
		Matcher match = patt.matcher(sourceCode);
		int i = 0;
		while (match.find()) {
			if (i >= nNameFounded) {
				int start = match.start("args");
				String args = match.group("args");
				String[] argsArray = args.replaceAll(" ", "").split(",");
				String newCode = sourceCode;
				for (String arg: argsArray) {
					NameToReplace ntp = new NameToReplace(arg, start, newCode);
					newCode =  ntp.replace();
				}
				return newCode;
			}
			++i;
		}
		return null;
	}
	
	public static String replaceAllArgs(String sourceCode, Pattern patt) {
		int nArgsFounded = 0;
		String newCode = replaceNewArgs(sourceCode, nArgsFounded, patt);
		while (newCode != null) {
			sourceCode = newCode;
			newCode = replaceNewArgs(sourceCode, nArgsFounded, patt);
			++nArgsFounded;
		}
		return sourceCode;
	}
	
	// ---- fin des fonctions pour le remplacement des arguments
	
	/*public static String removeBigComments(String sourceCode, Pattern patt) {
		Matcher match = patt.matcher(sourceCode);
		String newCode = sourceCode;
		while (match.find()) {
			int start = match.start();
			int end = match.end();
			newCode = newCode.substring(0, start)
				+newCode.substring(end, newCode.length());
			match = patt.matcher(newCode);
		}
		return newCode;
		}*/
	
	public static void main(String[] args) {
		if (args.length == 0) {
			System.out.println("args1 = fichier d'entier");
			System.out.println("optionellemnet args2 = fichier de sortie");
			System.exit(0);
		}
		String in = args[0];
		String out;
		if (args.length >= 2) {
			out = args[1];
		} else {
			out = null;
		}
		
		String content = ReadWrite.readFile(args[0]);
		content = content.replaceAll("//.*\n", "");
		
		// let/const
		Pattern varPattern = Pattern.compile("\\W((let)|(const)) +(?<name>[a-zA-Z_]\\w*)\\W");
		content = replaceAllName(content, varPattern);
		
		// args
		//Pattern argPattern = Pattern.compile("function +[a-zA-Z_]\\w* +\\( *([a-zA-Z_]\\w* *, *)*"
		//									 +"(?<name>[a-zA-Z_]\\w*) *([a-zA-Z_]\\w* *, *)*\\)");
		Pattern argPattern = Pattern.compile("function +([a-zA-Z_]\\w*)? *\\((?<args> *([a-zA-Z_]\\w* *, *)*"
											 +"[a-zA-Z_]\\w* *)\\)");
		content = replaceAllArgs(content, argPattern);
		
		// function
		Pattern funcPattern = Pattern.compile("function +(?<name>[a-zA-Z_]\\w*) *\\(");
		content = replaceAllName(content, funcPattern, NameToReplace.FUNCTION_SCOPE);
		
		content = content.replaceAll("\n", "");
		content = content.replaceAll("\t", " ");
		content = content.replaceAll(" +", " ");
		content = content.replaceAll("/\\*[^\\/]*\\*/", "");
		
		//Pattern bigCommentsPattern = Pattern.compile("/\\*[^\\/]*\\*/");
		//content = removeBigComments(content, bigCommentsPattern);
		
		if (out == null) {
			System.out.println(content);
		} else {
			ReadWrite.writeFile(out, content);
		}
	}
	
}
