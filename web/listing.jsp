<%-- 
    Document   : listing
    Created on : 8 Jun, 2018, 11:20:34 AM
    Author     : Administrator
--%>

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
            String path; %>
            <div style="float: left; padding-right: 1%;">
            <%out.println("<h1>Folders Available</h1>");
            out.println("<a href=\"Json files/.json"+"\" style='top:60px;' download>Download JSON file</a><br><br>");
            out.println("<table>");
            out.println("<tr><th>Path</th><th>No. of files</th></tr>");
            for(Map.Entry<String,Map<String,Integer>> en: jardata.getFolders().entrySet()){
                path=en.getKey();
                if(en.getKey().equals("")){
                    path="Unknown";
                }
                out.println("<tr>\n<td><button onclick=\"goto('folder','submitfold','"+path+"')\" class='cmds'>"+path+"</button></td>\n"
                            + "<td>"+en.getValue().size()+"</td>\n</tr>");
                
            }
            out.println("</table>");%>
            </div>
            <div style="float: left; padding-right: 1%;">
            <% out.println("<h1>Duplicate classes</h1>");
            out.println("<a href=\"Json files/.json"+"\" style='top:60px;' download>Download JSON file</a><br><br>");
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
                if(en.getValue().size()>1)
                    out.println("<tr>\n<td><button onclick=\"goto('duplicate','submitdup','"+en.getKey()+"')\" class='cmds'>"+en.getKey()+"</button></td>\n"
                            + "<td>"+en.getValue().size()+"</td>\n</tr>");
            }
            out.println("</table>");
            }else{
                out.println("<p> No Duplicate classes found </p>");
            }%>
            </div>
            <div style="float: left;">
            <%
            out.println("<h1>Anonymous classes</h1>");
            if(!jardata.getAnonymous().isEmpty()){
                out.println("<table>");
                out.println("<tr><th>Class file</th><th>No. of anonymous classes</th></tr>");
                out.println("<a href=\"Json files/.json"+"\" style='top:60px;' download>Download JSON file</a><br><br>");
                for(Map.Entry<String,Map<String,Integer>> en : jardata.getAnonymous().entrySet() ){
                    if(en.getValue().size()>0)
                        out.println("<tr>\n<td><button onclick=\"goto('anonymous','submitano','"+en.getKey()+"')\" class='cmds'>"+en.getKey()+"</button></td>\n"
                                + "<td>"+en.getValue().size()+"</td>\n</tr>");
                }
                out.println("</table>");
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
