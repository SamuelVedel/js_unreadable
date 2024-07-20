package fr.svedel.unreadable;

import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Nom à remplacer
 */
public class NameToReplace {
	
	public static final int MAX_NAME_LENGTH = 20;
	public static final int MIN_NAME_LENGTH = 20;
	
	/** nom d'origine */
	private String name;
	/** nouveau nom */
	private String newName;
	/** code source avant le changement de la variable*/
	private String sourceCode;
	/** indice du début de la portée de la variable */
	private int start;
	/** indice de la fin de la portée de la variable */
	private int end;
	
	public static final int VARIABLE_SCOPE = 0;
	public static final int FUNCTION_SCOPE = 1;
	private int scope;
	
	/**
	 * Inctentiation
	 *
	 * @param name nom d'origine de la variable
	 * @param start indice de début de la portée
	 * de la variable
	 * @param originCode code source d'origine
	 * utilisé pour trouvé la portée de fin
	 * @param scope portée de la variable.
	 * peut être :
	 * <ul>
	 * <li>VARIABLE_SCOPE</li>
	 * <li>FUNCTION_SCOPE</li>
	 */
	public NameToReplace(String name, int start, String sourceCode, int scope) {
		this.name = name;
		this.start = start;
		this.sourceCode = sourceCode;
		this.scope = scope;
		
		generateNewName();
		findEnd();
	}
	
	/**
	 * Inctentiation
	 *
	 * @param name nom d'origine de la variable
	 * @param start indice de début de la portée
	 * de la variable
	 * @param originCode code source d'origine
	 * utilisé pour trouvé la portée de fin
	 */
	public NameToReplace(String name, int start, String sourceCode) {
		this(name, start, sourceCode, VARIABLE_SCOPE);
	}
	
	private void generateNewName() {
		Random rand = new Random();
		int length;
		if (MIN_NAME_LENGTH < MAX_NAME_LENGTH) {
			length = rand.nextInt(MAX_NAME_LENGTH-MIN_NAME_LENGTH)+MIN_NAME_LENGTH;
		} else {
			length = MAX_NAME_LENGTH;
		}
		newName = "";
		for (int i = 0; i < length; ++i) {
			newName += (char)(rand.nextInt('z'-'a')+'a');
		}
	}
	
	private void findEnd() {
		switch (scope) {
		case VARIABLE_SCOPE:
			findEndForVariable();
			break;
		case FUNCTION_SCOPE:
			findEndForFunction();
			break;
		}
	}
	
	private void findEndForVariable() {
		// nombre d'accolade ouvrante rencontré
		int braceDepth = 0;
		int parenthesisDepth = 0;
		boolean loop = false;
		boolean enteredLoop = false;
		for (int i = start; i < sourceCode.length(); ++i) {
			switch (sourceCode.charAt(i)) {
			case '(':
				++parenthesisDepth;
				break;
			case ')':
				--parenthesisDepth;
				if (parenthesisDepth < 0) {
					// itterateur boulce for
					// ou argument
					loop = true;
				}
				break;
			case '{':
				++braceDepth;
				if (loop && !enteredLoop) {
					enteredLoop = true;
				}
				break;
			case '}':
				--braceDepth;
				if (braceDepth < 0
					|| (enteredLoop && braceDepth == 0)) {
					end = i;
					return;
				}
				break;
			}
		}
		end = sourceCode.length();
	}
	
	private void findEndForFunction() {
		findEndForVariable();
		if (end == sourceCode.length()-1) {
			start = 0;
		}
	}
	
	public String replace() {
		String newString = sourceCode.substring(0, start);
		int i = start;
		Matcher match = Pattern.compile("[^a-zA-Z_1-9\\.](?<call>"+name+")\\W").matcher(sourceCode);
		while (match.find()) {
			int st = match.start("call");
			int en = match.end("call");
			
			if (st < i) continue;
			if (en >= end) break;
			
			newString += sourceCode.substring(i, st);
			newString += newName;
			i = en;
		}
		
		newString += sourceCode.substring(i, sourceCode.length());
		return newString;
	}
}
