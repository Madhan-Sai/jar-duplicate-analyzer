<%-- 
    Document   : listing
    Created on : 8 Jun, 2018, 11:20:34 AM
    Author     : Administrator
--%>

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
        <link href="styles.css" rel="stylesheet"/>
        <% 
            JarParser jardata= (JarParser) request.getSession().getAttribute("jardata");
            /*for(JarData data:jardata.getData()){
                out.println("<p>"+data.getPath()+"\t"+data.getFileSize()+"</p>");
            }*/
            out.println("<h1>Duplicates</h1>");
            out.println("<table>");
            out.println("<tr><th>Class file</th><th>Count</th></tr>");
            for(Map.Entry<String,Integer> en : jardata.getDuplicates().entrySet() ){
                if(en.getValue()>1)
                    out.println("<tr>\n<td><button class='cmds' >"+en.getKey()+"</button></td>\n"
                            + "<td>"+en.getValue()+"</td>\n</tr>");
            }
            out.println("</table>");
        %>
    </body>
</html>
