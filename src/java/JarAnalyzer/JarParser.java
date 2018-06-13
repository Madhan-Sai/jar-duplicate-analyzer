/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package JarAnalyzer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 *
 * @author Administrator
 */
public class JarParser {
    private final List<JarData> data;
    private Map<String,ArrayList<JarData>> duplicates;
    private Map<String,Map<String,Integer>> anonymous;
    private final Map<String,Map<String,Integer>> folders;

    public JarParser() {
        data=new ArrayList<>();
        duplicates=null;
        anonymous=null;
        folders=new HashMap<>();
    }

    public List<JarData> getData() {
        return data;
    }
    
    
    public void addData(JarData jar){
        data.add(jar);
    }
    
    public void findDuplicates(){
        duplicates=new HashMap<>();
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
        anonymous=new HashMap<>();
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
                            Map<String,Integer> li=new HashMap<>();
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
        Map<String,Integer> fol=new HashMap<>();
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
        Map<String,Integer> dup=new HashMap<>();
        JSONArray foldercount=new JSONArray();
        dup=folders.get(RFolder);
        if(dup!=null){
            for(Map.Entry entry:dup.entrySet()){
                JSONObject inobj=new JSONObject();
                inobj.put("Folder-Name",entry.getKey());
                inobj.put("Count",entry.getValue());
                foldercount.add(inobj);
            }
        }
        return foldercount;
    }
    
    public JSONArray returnAnonymous(String RClass){
        Map<String,Integer> ano=new HashMap<>();
        JSONArray anocount=new JSONArray();
        ano=anonymous.get(RClass);
        if(ano!=null){
            for(Map.Entry entry:ano.entrySet()){
            JSONObject inobj=new JSONObject();
            inobj.put("Anonymous-Name",entry.getKey());
            inobj.put("Count",entry.getValue());
            anocount.add(inobj);
            }
        }
        return anocount;
    }
    
    public JSONArray returnDuplicates(String RClass){
        List<JarData> dup=new ArrayList<>();
        JSONArray duparray=new JSONArray();
        dup=duplicates.get(RClass);
        for(JarData jar:dup){
            JSONObject inobj=new JSONObject();
            inobj.put("name",jar.getFilename());
            inobj.put("FilePath",jar.getPath());
            inobj.put("Size",jar.fileSize);
            duparray.add(inobj);
        }
        return duparray;
    }
    
    public JSONArray findPairJars(){
        JSONArray pair=new JSONArray();
        for(Map.Entry<String,ArrayList<JarData>> en:duplicates.entrySet()){
            List<JarData> d=en.getValue();
            if(d.size()>1){
                JSONObject obj=new JSONObject();
                int count=1;
                for(JarData jr:d){
                    obj.put("jar "+count, jr.getFilename());
                    System.out.println(jr.getFilename());
                    count++;
                }
                if(!pair.contains(obj))
                    pair.add(obj);
            }
        }
        return pair;
    }
    
    public JSONArray findFiles(String jar1,String jar2){
        JSONArray files=new JSONArray();
        for(Map.Entry<String,ArrayList<JarData>> en:duplicates.entrySet()){
            List<JarData> d=en.getValue();
            if(d.size()>1){
                int count=0;
                JSONObject obj=new JSONObject();
                for(JarData js:d){
                    if(js.getFilename().equals(jar1)) count+=1;
                    if(js.getFilename().equals(jar2)) count+=1;
                }
                if(count==2){
                    obj.put("filename",en.getKey());
                    if(!files.contains(obj)) files.add(obj);
                }
            }
        }
        return files;
    }
}
