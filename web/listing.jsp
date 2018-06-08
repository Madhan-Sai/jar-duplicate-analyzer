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
        <% 
            JarParser jardata= (JarParser) request.getSession().getAttribute("jardata");
            /*for(JarData data:jardata.getData()){
                out.println("<p>"+data.getPath()+"\t"+data.getFileSize()+"</p>");
            }*/
            out.println("<h1>Duplicates</h1>");
            for(Map.Entry<String,Integer> en : jardata.getDuplicates().entrySet() ){
                if(en.getValue()>1)
                    out.println("<p>"+en.getKey()+"\t"+en.getValue()+"</p>");
            }
        %>
    </body>
</html>
