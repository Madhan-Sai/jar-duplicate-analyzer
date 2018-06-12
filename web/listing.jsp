<%-- 
    Document   : listing
    Created on : 8 Jun, 2018, 11:20:34 AM
    Author     : Administrator
--%>

<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="JarAnalyzer.JarData"%>
<%@page import="JarAnalyzer.JarParser"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <script src="scripts.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.11.4/themes/redmond/jquery-ui.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.4/css/ui.jqgrid.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.4/jquery.jqgrid.min.js"></script>
    <style>
        .ref{
        -webkit-appearance: button;
        -moz-appearance: button ;
        appearance: button;
        text-decoration: none;
        color:initial;
        position:fixed;
        top:10px;
        right:100px;
        }
    </style>
        <% 
            JarParser jardata= (JarParser) request.getSession().getAttribute("jardata");
            String path;
            ServletConfig sc=this.getServletConfig();String fname="";
            String filepath = "\\webapps\\JARAnalyzer\\JSON files\\";
            String dirp=System.getProperty("user.dir");
            String nfilepath=dirp+filepath;
            File dir=new File(nfilepath);
            if(!dir.exists()) dir.mkdir();%>
            <div style="float: left; padding-right: 1%;">
            <%
            JSONObject outerf=new JSONObject();    
            JSONArray arrf=new JSONArray();
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
            outerf.put("Folder Listing", arrf);
            FileWriter file=new FileWriter(filename);
            file.write(outerf.toJSONString());
            file.close();
            %>
            </div>
            <div style="float: left; padding-right: 1%;">
            <% 
            JSONObject outerd=new JSONObject();
            JSONArray arrd=new JSONArray();
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
            outerd.put("Duplicate Listing", arrd);
            file=new FileWriter(filename);
            file.write(outerd.toJSONString());
            file.close();
            }%>
            </div>
            <div style="float: left;">
            <%
            JSONArray arra=new JSONArray();
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
                outera.put("Anonymous Listing", arra);
                file=new FileWriter(filename);
                file.write(outera.toJSONString());
                file.close();
            }
        %>
            </div>
            <script>
                var inneranonymous=[];
                var innerduplicates=[];
                var innerfolders=[];
                <% 
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
                %>
    	$(function(){
    	$("#fol").jqGrid({
    		colModel:[{name:"Path",label:"Path",width:500},
    			{name:"No. of Files",label:"No. of Files",sorttype:"number"}],
    		data:<% out.print(arrf.toJSONString()); %>,
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
                        caption:"Classes inside "+data['Path']  
                    });
                }
    	});
    });
    $(function(){
    	$("#dup").jqGrid({
    		colModel:[{name:"Class File",label:"Class File",width:500},
    			{name:"No of times",label:"No of times",sorttype:"number"}],
    		data:<% out.print(arrd.toJSONString()); %>,
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
                            {name:"name",label:"name",width:200},
                            {name:"FilePath", label:"FilePath",width:300}],
                        data:innerduplicates[data['Class File']],
                        pager:true,
                        rowNum:5,
                        viewrecords:true,
                        caption:"Classes inside "+data['Class File']  
                    });
                }
    	});
    });
    $(function(){
    	$("#ano").jqGrid({
    		colModel:[{name:"Class File",label:"Class File",width:500},
    			{name:"No of classes",label:"No of classes",sorttype:"number"}],
    		data:<% out.print(arra.toJSONString()); %>,
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
                        caption:"Classes inside "+data['Class File']  
                    });
                }
    	});
    });
    </script>
    <a href="index.jsp" class="ref">&lt;&lt;Back</a>
    <table id="dup"></table><br>
    <table id="ano"></table><br>
    <table id="fol"></table><br>
    </body>
</html>
