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
    private Map<String,Integer> duplicates;

    public JarParser() {
        data=new ArrayList<JarData>();
        duplicates=null;
    }

    public List<JarData> getData() {
        return data;
    }
    
    
    public void addData(JarData jar){
        data.add(jar);
    }
    
    public void findDuplicates(){
        duplicates=new HashMap<String,Integer>();
        for(JarData jar:data){
            if(!jar.getPath().endsWith("/")){
                String className=jar.getPath().substring(jar.getPath().lastIndexOf("/")+1);
                if(className!=null){
                    if(duplicates.containsKey(className)){
                        int count=duplicates.get(className);
                        duplicates.put(className, count+1);
                    }else
                        duplicates.put(className,1);
                }
            }
        }
    }
    
    public Map<String,Integer> getDuplicates(){
        if(duplicates==null){
            findDuplicates();
        }
        return duplicates;
    }
    
}
