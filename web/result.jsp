<%-- 
    Document   : result
    Created on : 11 Jun, 2018, 10:57:52 AM
    Author     : Administrator
--%>

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
        <h1>Hello World!</h1>
        <% 
            JarParser jardata= (JarParser) request.getSession().getAttribute("jardata");
            if(request.getParameter("duplicate")!=null){
                out.println("<h1>"+request.getParameter("duplicate")+"</h1>");
            }else{
                List<String> li=jardata.getAnonymousDetail(request.getParameter("anonymous"));
                for(String sub:li){
                    out.println("<h1>"+sub+"</h1>");
                }
            }
        %>
    </body>
</html>
