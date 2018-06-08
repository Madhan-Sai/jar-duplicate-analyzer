<%-- 
    Document   : index
    Created on : 7 Jun, 2018, 7:23:41 PM
    Author     : Administrator
--%>

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
                <input type="file" name="file"/>
                <input type="submit" value="Submit"/>
            </form>
        </div>
        <div class="input" id="folderform">
            <h1>Upload the folder</h1>
            <form method="post" action="folderaction" enctype="multipart/form-data">
                <label>Select the folder</label><br><br>
                <input type="file" name="folder"  webkitdirectory directory/>
                <input type="submit" value="Submit folder"/>
            </form>
        </div>
        <div class="input" id="urlform">
            <h1>Through URL</h1>
            <form method="post" action="urlaction">
                <label>Provide the URL:</label><br><br>
                <input type="url" name="link"/>
                <input type="submit" value="Submit"/>
            </form>
        </div>
        <% request.getSession().removeAttribute("error"); %>
    </body>
</html>
