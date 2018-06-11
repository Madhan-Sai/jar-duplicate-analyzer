/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import JarAnalyzer.JarData;
import JarAnalyzer.JarParser;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 *
 * @author Administrator
 */
public class folderaction extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        File f;
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet folderaction</title>");            
            out.println("</head>");
            out.println("<body>");
            JarParser jardata=new JarParser();
            ServletContext sc=this.getServletContext();
            String filepath = sc.getInitParameter("destLocation");
            String fpath="";
            String dirp=System.getProperty("user.dir");
            filepath=dirp+filepath;
            String type=request.getContentType();
            if(type.contains("multipart/form-data")){
                DiskFileItemFactory df=new DiskFileItemFactory();
                File tempdir=new File(dirp+"\\webapps\\"+new File(getServletContext().getRealPath("/")).getName()+"\\temp");
                if(!tempdir.exists())
                    tempdir.mkdirs();  
                File dest=new File(filepath);
                if(!dest.exists())
                    dest.mkdirs();
                
                df.setRepository(tempdir);
                ServletFileUpload sfup=new ServletFileUpload(df);
                try {
                    List files=sfup.parseRequest(request);
                    Iterator i=files.iterator();
                    while(i.hasNext()){
                        FileItem fi=(FileItem) i.next();
                        String fieldName=fi.getFieldName();
                        String name=fi.getName();
                        name.replace("/","\\");
                        if(name.endsWith(".jar")){
                            if(name.lastIndexOf("//")>=0){
                                fpath=filepath+name.substring(name.lastIndexOf("//"));
                            }else{
                                fpath=filepath+name.substring(name.lastIndexOf("//")+1);
                            }
                            f=new File(fpath);
                            f.getParentFile().mkdirs();
                            fi.write(f);
                            JarFile jar=new JarFile(fpath);
                            Enumeration<JarEntry> enu=jar.entries();
                            while(enu.hasMoreElements()){
                                JarData djar=null;
                                JarEntry jarContent=enu.nextElement();
                                djar=new JarData(jarContent.getName(),jarContent.getSize(),new Date(jarContent.getTime()));
                                jardata.addData(djar);
                                jardata.addFolders(djar);
                            }
                        }
                    }
                    if(jardata!=null){
                        request.getSession().setAttribute("jardata", jardata);
                        response.sendRedirect("listing.jsp");
                    }else{
                        HttpSession session=request.getSession();
                        session.setAttribute("error", "This folder doesn't have any jar files");
                        response.sendRedirect("index.jsp");
                    }
                    return;
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
