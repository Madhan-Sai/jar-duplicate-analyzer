/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package JarAnalyzer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Administrator
 */
public class JarParser {
    private List<JarData> data;
    private HashMap<String,Integer> duplicates;

    public JarParser() {
        data=new ArrayList<JarData>();
        duplicates=new HashMap<String,Integer>();
    }
    
    public void addData(JarData jar){
        data.add(jar);
    }
    
    
    
}
