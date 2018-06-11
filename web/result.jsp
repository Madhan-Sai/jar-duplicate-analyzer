<%-- 
    Document   : result
    Created on : 11 Jun, 2018, 10:57:52 AM
    Author     : Administrator
--%>

<%@page import="java.io.FileWriter"%>
<%@page import="java.io.File"%>
<%@page import="JarAnalyzer.JarData"%>
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
            ServletConfig sc=this.getServletConfig();String fname="";
            String filepath = "\\webapps\\JARAnalyzer\\JSON files\\";
            String dirp=System.getProperty("user.dir");
            String nfilepath=dirp+filepath;
            File dir=new File(nfilepath);
            if(!dir.exists()) dir.mkdir();
            if(request.getParameter("folder")!=null){
                fname="folder-"+request.getParameter("folder").hashCode();
            }else if(request.getParameter("anonymous")!=null){
                fname=request.getParameter("anonymous");
            }else if(request.getParameter("duplicates")!=null){
                fname=request.getParameter("duplicates");
            }
            String filename=nfilepath+fname+".json";
            filename.replace("/", "//");
            FileWriter file=new FileWriter(filename);
            if(request.getParameter("folder")!=null)
                file.write(jardata.returnFolders(request.getParameter("folder")).toJSONString());
            else if(request.getParameter("anonymous")!=null)
                file.write(jardata.returnAnonymous(request.getParameter("anonymous")).toJSONString());
            else if(request.getParameter("duplicates")!=null)
                file.write(jardata.returnAnonymous(request.getParameter("duplicates")).toJSONString());
            file.close();
            if(request.getParameter("duplicate")!=null){
                List<JarData> list=jardata.getDuplicatesPath(request.getParameter("duplicate"));
                out.println("<h1>Path of duplicate class "+request.getParameter("duplicate")+" are:</h1>");
                out.println("<table>");
                out.println("<tr><th>Path</th><th>Last Modified Date</th><th>File size in Bytes</th></tr>");
                for(JarData path:list){
                    out.println("<tr>\n<td>"+path.getPath()+"</td>\n<td>"+path.getLastModified()+"</td>\n<td>"+path.getFileSize()+"</td>\n</tr>");
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
                Map<String,Integer> list=jardata.getFolderFiles(request.getParameter("folder"));
                jardata.returnFolders(request.getParameter("folder"));
                out.println("<h1>The class files in "+request.getParameter("folder")+" folder are:</h1>");
                out.println("<table>");
                out.println("<tr><th>Class file</th><th>No. of times repeated</th></tr>");
                for(Map.Entry<String,Integer> en:list.entrySet()){
                    out.println("<tr>\n<td>"+en.getKey()+"</td>\n<td>"+en.getValue()+"</td>\n</tr>");
                }
                out.println("</table>");
            }
            out.println("<a style='position:fixed;top:50px;right:10px;' href=\"JSON files/"+fname+".json"+"\" style='top:60px;' download>Download JSON file</a><br><br>");
        %>
    </body>
</html>
