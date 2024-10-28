package fr.svedel.unreadable;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;


public class ReadWrite {
	
	public static String readFile(String filePath) {
		int nLine = 0;
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(
													   new FileInputStream(filePath),
													   "utf-8"));
			
			while ((reader.readLine()) != null) {
				++nLine;
			}
			
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		String[] content = new String[nLine];
		
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(
													   new FileInputStream(filePath),
													   "utf-8"));
			int i = 0;
			
			String line;
			while ((line = reader.readLine()) != null) {
				content[i] = line;
				++i;
			}
			
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return concat(content);
	}
	
	public static String concat(String[] strs) {
		String result = "";
		for (String str: strs) {
			result = result.concat("\n").concat(str);
		}
		return result;
	}
	
	public static void writeFile(String filePath, String content) {
		try {
			FileOutputStream fos = new FileOutputStream(filePath);
			fos.write(content.getBytes());
			fos.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
