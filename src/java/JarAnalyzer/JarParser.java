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
    private Map<String,ArrayList> anonymous;
    private Map<String,ArrayList> folders;

    public JarParser() {
        data=new ArrayList<JarData>();
        duplicates=null;
        anonymous=null;
        folders=new HashMap<String,ArrayList>();
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
                if(className!=null&&className.endsWith(".class")){
                    if(duplicates.containsKey(className)){
                        int count=duplicates.get(className);
                        duplicates.put(className, count+1);
                    }else
                        duplicates.put(className,1);
                }
            }
        }
    }
    
    public void findAnonymous(){
        anonymous=new HashMap<String,ArrayList>();
        for(JarData jar:data){
            if(!jar.getPath().endsWith("/")){
                String className=jar.getPath().substring(jar.getPath().lastIndexOf("/")+1);
                if(className!=null && className.endsWith(".class")){
                    if(className.contains("$")){
                        String mainClass=className.substring(0,className.indexOf("$"));
                        String anonymousClass=className.substring(className.indexOf("$")+1,className.lastIndexOf(".class"));
                        if(anonymous.containsKey(mainClass)){
                            ArrayList li=anonymous.get(mainClass);
                            li.add(anonymousClass);
                            anonymous.put(mainClass, li);
                        }else{
                            ArrayList li=new ArrayList();
                            li.add(anonymousClass);
                            anonymous.put(mainClass,li);
                        }
                    }
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
    
    public Map<String,ArrayList> getAnonymous(){
        if(anonymous==null)
            findAnonymous();
        return anonymous;
    }
    
    public void addFolders(JarData jar){
        ArrayList<String>fol=new ArrayList<String>();
        if(! jar.path.substring(jar.path.lastIndexOf("/")+1).equals("")){
            String jpath=jar.path.substring(0,jar.path.lastIndexOf("/")+1);
            String fname=jar.path.substring(jpath.lastIndexOf("/")+1);
            if(jpath!=null){
            if(folders.containsKey(jpath)){
                fol=folders.get(jpath);
                fol.add(fname);
                folders.put(jpath, fol);
            }
            else{
                fol.add(fname);
                folders.put(jpath, fol);
            }
            }
        }
    }
    
    public List<String> getAnonymousDetail(String key){
        return anonymous.get(key);
    }
    
        public Map<String,ArrayList> getFolders(){
        //if(folders==null)
            //addFolders();
        return folders;
    }
}
