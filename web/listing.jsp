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
        <script>
            function goto(id,btn,cmd){
                ele=document.getElementById(id);
                if(cmd==="Unknown")
                    cmd="";
                ele.value=cmd;
                document.getElementById(btn).click();
            }
        </script>        
        <link href="styles.css" rel="stylesheet"/>
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
            JSONObject outer=new JSONObject();    
            JSONArray arr=new JSONArray();
            String filename=nfilepath+"folders.json";
            out.println("<h1>Folders Available</h1>");
            out.println("<a href=\"JSON files/folders.json\" style='top:60px;' download>Download JSON file</a><br><br>");
            out.println("<table>");
            out.println("<tr><th>Path</th><th>No. of files</th></tr>");
            for(Map.Entry<String,Map<String,Integer>> en: jardata.getFolders().entrySet()){
                JSONObject inner=new JSONObject();
                path=en.getKey();
                if(en.getKey().equals("")){
                    path="Unknown";
                }
                out.println("<tr>\n<td><button onclick=\"goto('folder','submitfold','"+path+"')\" class='cmds'>"+path+"</button></td>\n"
                            + "<td>"+en.getValue().size()+"</td>\n</tr>");
                inner.put("Path", path);
                inner.put("No. of Files",en.getValue().size());
                arr.add(inner);
            }
            outer.put("Folder Listing", arr);
            FileWriter file=new FileWriter(filename);
            file.write(outer.toJSONString());
            file.close();
            out.println("</table>");%>
            </div>
            <div style="float: left; padding-right: 1%;">
            <% 
            outer.clear();
            arr.clear();
            filename=nfilepath+"duplicates.json";
            out.println("<h1>Duplicate classes</h1>");
            out.println("<a href=\"JSON files/duplicates.json\" style='top:60px;' download>Download JSON file</a><br><br>");
            boolean isDup=false;
            for(Map.Entry<String,ArrayList<JarData>> en : jardata.getDuplicates().entrySet() ){
                if(en.getValue().size()>1){
                    isDup=true;
                    break;
                }
            }
            if(isDup){
            out.println("<table>");
            out.println("<tr><th>Class file</th><th>No. of times repeated</th></tr>");
            for(Map.Entry<String,ArrayList<JarData>> en : jardata.getDuplicates().entrySet() ){
                if(en.getValue().size()>1){
                    JSONObject inner=new JSONObject();
                    out.println("<tr>\n<td><button onclick=\"goto('duplicate','submitdup','"+en.getKey()+"')\" class='cmds'>"+en.getKey()+"</button></td>\n"
                            + "<td>"+en.getValue().size()+"</td>\n</tr>");
                    inner.put("Class File", en.getKey());
                    inner.put("No of times",en.getValue().size());
                    arr.add(inner);
                }
            }
            out.println("</table>");
            outer.put("Duplicate Listing", arr);
            file=new FileWriter(filename);
            file.write(outer.toJSONString());
            file.close();
            }else{
                out.println("<p> No Duplicate classes found </p>");
            }%>
            </div>
            <div style="float: left;">
            <%
            out.println("<h1>Anonymous classes</h1>");
            if(!jardata.getAnonymous().isEmpty()){
                outer.clear();
                arr.clear();
                filename=nfilepath+"anonymous.json";
                out.println("<table>");
                out.println("<tr><th>Class file</th><th>No. of anonymous classes</th></tr>");
                out.println("<a href=\"JSON files/anonymous.json\" style='top:60px;' download>Download JSON file</a><br><br>");
                for(Map.Entry<String,Map<String,Integer>> en : jardata.getAnonymous().entrySet() ){
                    if(en.getValue().size()>0){
                        JSONObject inner=new JSONObject();
                        out.println("<tr>\n<td><button onclick=\"goto('anonymous','submitano','"+en.getKey()+"')\" class='cmds'>"+en.getKey()+"</button></td>\n"
                                + "<td>"+en.getValue().size()+"</td>\n</tr>");
                        inner.put("Class File", en.getKey());
                        inner.put("No of classes",en.getValue().size());
                        arr.add(inner);
                    }
                }
                out.println("</table>");
                outer.put("Anonymous Listing", arr);
                file=new FileWriter(filename);
                file.write(outer.toJSONString());
                file.close();
            }else{
                out.println("<p> No anonymous classes found </p>");
            }
        %>
            </div>
        <form method="post" action="result.jsp">
            <input type="text" name="duplicate" id="duplicate" hidden/>
            <input type="submit" id="submitdup" hidden/>
        </form>
        <form method="post" action="result.jsp">
            <input type="text" name="anonymous" id="anonymous" hidden/>
            <input type="submit" id="submitano" hidden/>
        </form>
        <form method="post" action="result.jsp">
            <input type="text" name="folder" id="folder" hidden/>
            <input type="submit" id="submitfold" hidden/>
        </form>
    </body>
</html>
