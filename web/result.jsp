<%-- 
    Document   : result
    Created on : 11 Jun, 2018, 10:57:52 AM
    Author     : Administrator
--%>

<%@page import="java.util.Map"%>
<%@page import="JarAnalyzer.JarParser"%>
<%@page import="java.util.List"%>
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
            if(request.getParameter("duplicate")!=null){
                List<String> list=jardata.getDuplicatesPath(request.getParameter("duplicate"));
                out.println("<h1>Path of duplicate class "+request.getParameter("duplicate")+" are:</h1>");
                out.println("<table>");
                out.println("<tr><th>Path</th></tr>");
                for(String path:list){
                    out.println("<tr>\n<td>"+path+"</td>\n</tr>");
                }
                out.println("</table>");
            }else if(request.getParameter("anonymous")!=null){
                Map<String,Integer> li=jardata.getAnonymousDetail(request.getParameter("anonymous"));
                out.println("<h1>Anonymous classes inside "+request.getParameter("anonymous")+" are:</h1>");
                out.println("<table>");
                out.println("<tr><th>Anonymous Class name</th><th>No. Of times repeated</th></tr>");
                for(Map.Entry<String,Integer> en:li.entrySet()){
                    out.println("<tr>\n<td>"+en.getKey()+"</td>\n<td>"+en.getValue()+"</td>\n</tr>");
                }
                out.println("</table>");
            }else{
                List<String> list=jardata.getFolderFiles(request.getParameter("folder"));
                out.println("<h1>The class files in "+request.getParameter("folder")+" folder are:</h1>");
                out.println("<table>");
                out.println("<tr><th>Class file</th></tr>");
                for(String path:list){
                    out.println("<tr>\n<td>"+path+"</td>\n</tr>");
                }
                out.println("</table>");
            }
        %>
    </body>
</html>
