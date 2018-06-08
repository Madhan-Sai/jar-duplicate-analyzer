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
        <h1>Folder upload</h1>
        <form method="post" action="folderaction" enctype="multipart/form-data">
            <label>Select the folder</label><br><br>
            <input type="file" name="folder"  webkitdirectory directory/>
            <input type="submit" value="Submit folder"/>
        </form>
    </body>
</html>
