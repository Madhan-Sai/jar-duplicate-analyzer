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
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 *
 * @author Administrator
 */
public class JarParser {
    private List<JarData> data;
    private Map<String,ArrayList<JarData>> duplicates;
    private Map<String,Map<String,Integer>> anonymous;
    private Map<String,Map<String,Integer>> folders;

    public JarParser() {
        data=new ArrayList<JarData>();
        duplicates=null;
        anonymous=null;
        folders=new HashMap<String,Map<String,Integer>>();
    }

    public List<JarData> getData() {
        return data;
    }
    
    
    public void addData(JarData jar){
        data.add(jar);
    }
    
    public void findDuplicates(){
        duplicates=new HashMap<String,ArrayList<JarData>>();
        for(JarData jar:data){
            if(!jar.getPath().endsWith("/")){
                String className=jar.getPath().substring(jar.getPath().lastIndexOf("/")+1);
                if(className!=null&&className.endsWith(".class")){
                    if(duplicates.containsKey(jar.getPath())){
                        ArrayList<JarData> count=duplicates.get(jar.getPath());
                        count.add(jar);
                        duplicates.put(jar.getPath(), count);
                    }else{
                        ArrayList<JarData> c=new ArrayList<>();
                        c.add(jar);
                        duplicates.put(jar.getPath(),c);
                    }
                }
            }
        }
    }
    
    public void findAnonymous(){
        anonymous=new HashMap<String,Map<String,Integer>>();
        for(JarData jar:data){
            if(!jar.getPath().endsWith("/")){
                String className=jar.getPath().substring(jar.getPath().lastIndexOf("/")+1);
                if(className!=null && className.endsWith(".class")){
                    if(className.contains("$")){
                        String mainClass=className.substring(0,className.indexOf("$"));
                        String anonymousClass=className.substring(className.indexOf("$")+1,className.lastIndexOf(".class"));
                        if(anonymous.containsKey(mainClass)){
                            Map<String,Integer> li=anonymous.get(mainClass);
                            if(li.containsKey(anonymousClass)){
                                int count=li.get(anonymousClass);
                                li.put(anonymousClass,count+1);
                            }
                            else{
                                li.put(anonymousClass,1);
                            }
                            anonymous.put(mainClass, li);
                        }else{
                            Map<String,Integer> li=new HashMap<String,Integer>();
                            li.put(anonymousClass,1);
                            anonymous.put(mainClass,li);
                        }
                    }
                }
            }
        }
    }
    
    public Map<String,ArrayList<JarData>> getDuplicates(){
        if(duplicates==null){
            findDuplicates();
        }
        return duplicates;
    }
    
    public Map<String,Map<String,Integer>> getAnonymous(){
        if(anonymous==null)
            findAnonymous();
        return anonymous;
    }
    
    public void addFolders(JarData jar){
        Map<String,Integer> fol=new HashMap<String,Integer>();
        if(! jar.path.substring(jar.path.lastIndexOf("/")+1).equals("")){
            String jpath=jar.path.substring(0,jar.path.lastIndexOf("/")+1);
            String fname=jar.path.substring(jpath.lastIndexOf("/")+1);
            if(jpath!=null && fname.endsWith(".class")){
            if(folders.containsKey(jpath)){
                fol=folders.get(jpath);
                if(fol.containsKey(fname))
                {
                    int c=fol.get(fname);
                    fol.put(fname, c+1);
                }else{
                    fol.put(fname,1);
                }
                folders.put(jpath, fol);
            }
            else{
                fol.put(fname,1);
                folders.put(jpath, fol);
            }
            }
        }
    }
    
    public Map<String,Integer> getAnonymousDetail(String key){
        return anonymous.get(key);
    }
    
    public Map<String,Map<String,Integer>> getFolders(){
        return folders;
    }
    
    public List<JarData> getDuplicatesPath(String path){
        return duplicates.get(path);
    }
    
    public Map<String,Integer> getFolderFiles(String fname){
        return folders.get(fname);
    }
    
    public JSONArray returnFolders(String RFolder){
        Map<String,Integer> dup=new HashMap<String,Integer>();
        JSONObject dupfiles=new JSONObject();
        JSONArray foldercount=new JSONArray();
        dup=folders.get(RFolder);
        if(dup!=null){
            for(Map.Entry entry:dup.entrySet()){
                JSONObject inobj=new JSONObject();
                inobj.put("Folder-Name",entry.getKey());
                inobj.put("Count",entry.getValue());
                foldercount.add(inobj);
            }
        dupfiles.put("Folder-Path  --  Count",foldercount);
        }
        return foldercount;
    }
    
    public JSONArray returnAnonymous(String RClass){
        JSONObject anofiles=new JSONObject();
        Map<String,Integer> ano=new HashMap<String,Integer>();
        JSONArray anocount=new JSONArray();
        ano=anonymous.get(RClass);
        if(ano!=null){
            for(Map.Entry entry:ano.entrySet()){
            JSONObject inobj=new JSONObject();
            inobj.put("Anonymous-Name",entry.getKey());
            inobj.put("Count",entry.getValue());
            anocount.add(inobj);
            }
            anofiles.put("Anonymous-Class  --  Count",anocount);
        }
        return anocount;
    }
    
    public JSONArray returnDuplicates(String RClass){
        JSONObject dupfile=new JSONObject();
        List<JarData> dup=new ArrayList<JarData>();
        JSONArray duparray=new JSONArray();
        dup=duplicates.get(RClass);
        for(JarData jar:dup){
            JSONObject inobj=new JSONObject();
            inobj.put("FilePath",jar.fileSize);
            inobj.put("Last Modified Date:",jar.lastModified);
            inobj.put("Size",jar.fileSize);
            duparray.add(inobj);
        }
        dupfile.put("Duplicate Class  --  Count",duparray);
        return duparray;
    }
}
