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
    private Map<String,ArrayList> duplicates;
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
        duplicates=new HashMap<String,ArrayList>();
        for(JarData jar:data){
            if(!jar.getPath().endsWith("/")){
                String className=jar.getPath().substring(jar.getPath().lastIndexOf("/")+1);
                if(className!=null&&className.endsWith(".class")){
                    if(duplicates.containsKey(className)){
                        ArrayList<String> count=duplicates.get(className);
                        count.add(jar.getPath());
                        duplicates.put(className, count);
                    }else{
                        ArrayList<String> c=new ArrayList<>();
                        c.add(jar.getPath());
                        duplicates.put(className,c);
                    }
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
    
    public Map<String,ArrayList> getDuplicates(){
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
    
    public Map<String,Integer> getAnonymousDetail(String key){
        List <String> lis=anonymous.get(key);
        Map<String,Integer> anonym=new HashMap<String,Integer>();
        for(String li:lis){
            if(anonym.containsKey(li)){
                int k=anonym.get(li);
                anonym.put(li, k+1);
            }else{
                anonym.put(li, 1);
            }
        }
        return anonym;
    }
    
    public Map<String,ArrayList> getFolders(){
        return folders;
    }
    
    public List<String> getDuplicatesPath(String path){
        return duplicates.get(path);
    }
    
    public List<String> getFolderFiles(String fname){
        return folders.get(fname);
    }
}
