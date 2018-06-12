<%-- 
    Document   : index
    Created on : 7 Jun, 2018, 7:23:41 PM
    Author     : Administrator
--%>

<%@page import="java.io.File"%>
<%@page import="JarAnalyzer.JarParser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="JarAnalyzer.JarData"%>
<%@page import="java.util.Map"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.io.FileWriter"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.11.4/themes/redmond/jquery-ui.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.4/css/ui.jqgrid.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.4/jquery.jqgrid.min.js"></script>
        <script src="scripts.js"></script>
        <link href="styles.css" rel="stylesheet"/>
        <h1>Jar file Analyzer</h1>
        <input type="radio" name="type" id="zip" onclick="viewform('input','zipform')" /><label>Zip file</label>
        <input type="radio" name="type" id="folder" onclick="viewform('input','folderform')" /><label>Jar Folder upload</label>
        <input type="radio" name="type" id="url" onclick="viewform('input','urlform')" /><label>URL of jar file</label>
        <% 
        if(request.getSession().getAttribute("error")!=null)
            out.println("<p style='color:red'>*"+request.getSession().getAttribute("error")+"</p>");
        %>
        <div class="input" id="zipform">
            <h1>ZIP Upload</h1>
            <form method="post" action="zipaction" enctype="multipart/form-data">
                <label>Upload the Zip file</label><br><br>
                <input type="file" name="file" accept=".zip" required/>
                <input type="submit" value="Submit"/>
            </form>
        </div>
        <div class="input" id="folderform">
            <h1>Upload the folder</h1>
            <form method="post" action="folderaction" enctype="multipart/form-data">
                <label>Select the folder</label><br><br>
                <input type="file" name="folder" required webkitdirectory directory/>
                <input type="submit" value="Submit folder"/>
            </form>
        </div>
        <div class="input" id="urlform">
            <h1>Through URL</h1>
            <form method="post" action="urlaction">
                <label>Provide the URL:</label><br><br>
                <input type="url" name="link" required/>
                <input type="submit" value="Submit"/>
            </form>
        </div><br><br>
        <% request.getSession().removeAttribute("error"); 
        JSONArray arrd=null,arrf=null,arra=null;
        JarParser jardata=null;
        %>
        <% if(request.getSession().getAttribute("jardata")!=null){
            jardata= (JarParser) request.getSession().getAttribute("jardata");
            String path;
            ServletConfig sc=this.getServletConfig();String fname="";
            String filepath = "\\webapps\\JARAnalyzer\\JSON files\\";
            String dirp=System.getProperty("user.dir");
            String nfilepath=dirp+filepath;
            File dir=new File(nfilepath);
            if(!dir.exists()) dir.mkdir();
            arrf=new JSONArray();
            String filename=nfilepath+"folders.json";
            for(Map.Entry<String,Map<String,Integer>> en: jardata.getFolders().entrySet()){
                JSONObject inner=new JSONObject();
                path=en.getKey();
                if(en.getKey().equals("")){
                    path="Unknown";
                }
                inner.put("Path", path);
                inner.put("No. of Files",en.getValue().size());
                arrf.add(inner);
            }
            
            arrd=new JSONArray();
            filename=nfilepath+"duplicates.json";
            boolean isDup=false;
            for(Map.Entry<String,ArrayList<JarData>> en : jardata.getDuplicates().entrySet() ){
                if(en.getValue().size()>1){
                    isDup=true;
                    break;
                }
            }
            if(isDup){
            for(Map.Entry<String,ArrayList<JarData>> en : jardata.getDuplicates().entrySet() ){
                if(en.getValue().size()>1){
                    JSONObject inner=new JSONObject();
                    inner.put("Class File", en.getKey());
                    inner.put("No of times",en.getValue().size());
                    arrd.add(inner);
                }
            }
            }
            
            arra=new JSONArray();
            if(!jardata.getAnonymous().isEmpty()){
                JSONObject outera=new JSONObject();
                filename=nfilepath+"anonymous.json";
                for(Map.Entry<String,Map<String,Integer>> en : jardata.getAnonymous().entrySet() ){
                    if(en.getValue().size()>0){
                        JSONObject inner=new JSONObject();
                        inner.put("Class File", en.getKey());
                        inner.put("No of classes",en.getValue().size());
                        arra.add(inner);
                    }
                }
            }
        }
        %>
            <script>
                var inneranonymous=[];
                var innerduplicates=[];
                var innerfolders=[];
                <% 
                    if(jardata!=null){
                for(int i=0;i<arra.size();i++){
                    JSONObject ob= (JSONObject) arra.get(i);
                    out.print("inneranonymous['"+ob.get("Class File").toString()+"']="+jardata.returnAnonymous(ob.get("Class File").toString()).toJSONString()+";\n");
                }
                for(int i=0;i<arrd.size();i++){
                    JSONObject ob= (JSONObject) arrd.get(i);
                    out.print("innerduplicates['"+ob.get("Class File").toString()+"']="+jardata.returnDuplicates(ob.get("Class File").toString()).toJSONString()+";\n");
                }
                for(int i=0;i<arrf.size();i++){
                    JSONObject ob= (JSONObject) arrf.get(i);
                    out.print("innerfolders['"+ob.get("Path").toString()+"']="+jardata.returnFolders(ob.get("Path").toString()).toJSONString()+";\n");
                }
                    }
                %>
    	$(function(){
    	$("#fol").jqGrid({
    		colModel:[{name:"Path",label:"Path",width:500},
    			{name:"No. of Files",label:"No. of Files",sorttype:"number"}],
    		data:<%if(arrf!=null)
                        out.print(arrf.toJSONString()); %>,
    		idprefix:"a1_",
    		pager:true,
    		rowNum:5,
    		rownumbers:true,
    		caption:"Packages",
    		viewrecords:true,
                sortorder:"desc",
                sortname:"No. of Files",
                subGrid:true,
                subGridOptions:{
                    "reloadOnExpand":true,
                    "selectOnExpand":true
                },
                subGridRowExpanded: function(subgrid_id,row_id){
                    var data=jQuery("#fol").getRowData(row_id);
                    var subgrid_table_id, pager_id;
                    subgrid_table_id=subgrid_id+"_t";
                    pager_id="p_"+subgrid_table_id;
                    $("#"+subgrid_id).html("<table id="+subgrid_table_id+" class='scroll'></table><div id='"+pager_id+"' class='scroll'></div>");
                    $("#"+subgrid_table_id).jqGrid({
                        colModel:[
                            {name:"Folder-Name",label:"Folder-Name",width:300},
                            {name:"Count", label:"Count"}],
                        data:innerfolders[data['Path']],
                        pager:true,
                        rowNum:5,
                        viewrecords:true,
                        headertitles:true,
                        ignoreCase:true,
                        searching:{
                            defaultSearch:"cn"
                        },
                        caption:"Classes inside "+data['Path']  
                    }).jqGrid("filterToolbar",{defaultSearch:"cn"});
                }
    	}).jqGrid("filterToolbar",{defaultSearch:"cn"});
    });

    $(function(){
    	$("#ano").jqGrid({
    		colModel:[{name:"Class File",label:"Class File",width:500},
    			{name:"No of classes",label:"No of classes",sorttype:"number"}],
    		data:<%if(arra!=null) out.print(arra.toJSONString()); %>,
    		idprefix:"f1_",
    		pager:true,
    		rowNum:5,
    		rownumbers:true,
    		caption:"Anonymous Classes",
    		viewrecords:true,
                sortorder:"desc",
                sortname:"No of classes",
                subGrid:true,
                subGridOptions:{
                    "reloadOnExpand":true,
                    "selectOnExpand":true
                },
                subGridRowExpanded: function(subgrid_id,row_id){
                    var data=jQuery("#ano").getRowData(row_id);
                    var subgrid_table_id, pager_id;
                    subgrid_table_id=subgrid_id+"_t";
                    pager_id="p_"+subgrid_table_id;
                    $("#"+subgrid_id).html("<table id="+subgrid_table_id+" class='scroll'></table><div id='"+pager_id+"' class='scroll'></div>");
                    $("#"+subgrid_table_id).jqGrid({
                        colModel:[
                            {name:"Anonymous-Name",label:"Anonymous-Name",width:300},
                            {name:"Count", label:"Count"}],
                        data:inneranonymous[data['Class File']],
                        pager:true,
                        rowNum:5,
                        viewrecords:true,
                        headertitles:true,
                        sortIconsBeforeText:true,
                        searching:{
                            defaultSearch:"cn"
                        },
                        caption:"Classes inside "+data['Class File']  
                    }).jqGrid("filterToolbar",{defaultSearch:"cn"});
                }
    	}).jqGrid("filterToolbar",{defaultSearch:"cn"});
    });
        $(function(){
    	$("#dup").jqGrid({
    		colModel:[{name:"Class File",label:"Class File",width:500},
    			{name:"No of times",label:"No of times",sorttype:"number"}],
    		data:<%if(arrd!=null) out.print(arrd.toJSONString()); %>,
    		idprefix:"d1_",
    		pager:true,
    		rowNum:5,
    		rownumbers:true,
    		caption:"Duplicate Classes",
    		viewrecords:true,
                sortorder:"desc",
                sortname:"No of times",
                subGrid:true,
                subGridOptions:{
                    "reloadOnExpand":true,
                    "selectOnExpand":true
                },
                subGridRowExpanded: function(subgrid_id,row_id){
                    var data=jQuery("#dup").getRowData(row_id);
                    var subgrid_table_id, pager_id;
                    subgrid_table_id=subgrid_id+"_t";
                    pager_id="p_"+subgrid_table_id;
                    $("#"+subgrid_id).html("<table id="+subgrid_table_id+" class='scroll'></table><div id='"+pager_id+"' class='scroll'></div>");
                    $("#"+subgrid_table_id).jqGrid({
                        colModel:[
                            {name:"name",label:"name",width:300},
                            {name:"FilePath", label:"FilePath",width:250},
                            {name:"Size",label:"Size",width:50}],
                        data:innerduplicates[data['Class File']],
                        pager:true,
                        rowNum:5,
                        viewrecords:true,
                        headertitles:true,
                        sortIconsBeforeText:true,
                        searching:{ 
                            defaultSearch:"cn"
                        },
                        caption:"Classes inside "+data['Class File']  
                    }).jqGrid("filterToolbar",{defaultSearch:"cn"});
                }
    	}).jqGrid("filterToolbar",{defaultSearch:"cn"});
    });
    </script>
    <% if(jardata!=null){
        out.println("<table id='dup'></table><br>");
        out.println("<table id='ano'></table><br>");
        out.println("<table id='fol'></table><br>");
        out.println("<h1>"+jardata.findPairJars().toJSONString()+"</h1>");
    }%>
    </body>
</html>
