<%-- 
    Document   : listing
    Created on : 8 Jun, 2018, 11:20:34 AM
    Author     : Administrator
--%>

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
                ele.value=cmd;
                document.getElementById(btn).click();
            }
        </script>        
        <link href="styles.css" rel="stylesheet"/>
        <% 
            JarParser jardata= (JarParser) request.getSession().getAttribute("jardata");
            /*for(JarData data:jardata.getData()){
                out.println("<p>"+data.getPath()+"\t"+data.getFileSize()+"</p>");
            }*/
            out.println("<div >");
            out.println("<h1>Folder Listing</h1>");
            out.println("<table class='float-left'>");
            out.println("<tr><th>Path</th><th>Count</th></tr>");
            for(Map.Entry<String,ArrayList> en: jardata.getFolders().entrySet()){
                    out.println("<tr>\n<td><button onclick=\"goto('folder','submitfolder','"+en.getKey()+"')\" class='cmds'>"+en.getKey()+"</button></td>\n"
                            + "<td>"+en.getValue().size()+"</td>\n</tr>");
            }
            out.println("</table>");
            out.println("</div>");
            
            out.println("<div >");
            out.println("<h1>Duplicates</h1>");
            out.println("<table class='float-right'>");
            out.println("<tr><th>Class file</th><th>Count</th></tr>");
            for(Map.Entry<String,Integer> en : jardata.getDuplicates().entrySet() ){
                if(en.getValue()>1)
                    out.println("<tr>\n<td><button onclick=\"goto('duplicate','submitdup','"+en.getKey()+"')\" class='cmds'>"+en.getKey()+"</button></td>\n"
                            + "<td>"+en.getValue()+"</td>\n</tr>");
            }
            out.println("</table>");
            out.println("</div>");
            
            out.println("<h1>Anonymous</h1>");
            out.println("<table>");
            out.println("<tr><th>Class file</th><th>Count</th></tr>");
            for(Map.Entry<String,ArrayList> en : jardata.getAnonymous().entrySet() ){
                if(en.getValue().size()>0)
                    out.println("<tr>\n<td><button onclick=\"goto('anonymous','submitano','"+en.getKey()+"')\" class='cmds'>"+en.getKey()+"</button></td>\n"
                            + "<td>"+en.getValue().size()+"</td>\n</tr>");
            }
            out.println("</table>");
        %>
        <form method="post" action="result.jsp">
            <input type="text" name="duplicate" id="duplicate" hidden/>
            <input type="submit" id="submitdup" hidden/>
        </form>
        <form method="post" action="result.jsp">
            <input type="text" name="anonymous" id="anonymous" hidden/>
            <input type="submit" id="submitano" hidden/>
        </form>
    </body>
</html>
